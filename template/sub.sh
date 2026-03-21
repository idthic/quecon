#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_TMPDIR='%%TMPDIR%%'
QUECON_NNODE='%%NNODE%%'
##
## @var QUECON_NODE
##   If the current job scheduler starts the submitted script in every node,
##   "quecon/system:SYSTEM/emit-submit-header" is supposed to generate the code
##   to obtain the current job ID and assign QUECON_NODE.
##
## @fn system_start_node node_script_file
##   This function defines the system-specific way of starting the node
##   processing.
##
system_start_node() { builtin eval -- "$1"; }
# __QUECON_END_PARAMS__

#------------------------------------------------------------------------------
# definitions

function root_stat_log {
  echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_JOBDIR/stat.log"
}
function root_stat_var {
  local q=\' Q="'\''"
  printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$QUECON_JOBDIR/stat.sh"
}

## @fn node_stat_var var value
##   @var[in] inode
function node_stat_var {
  local q=\' Q="'\''" fstat
  printf -v fstat '%s/node%03d/stat.sh' "$QUECON_JOBDIR" "$inode"
  printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$fstat"
}

## @fn node_stat_fail
##   @var[in] inode
function node_stat_fail {
  local fstat
  printf -v fstat '%s/node%03d/stat.sh' "$QUECON_JOBDIR" "$inode"
  printf '%s\n' '((fail++))' >> "$fstat"
}

function node_try_start {
  local inode=$1
  if ! [[ $inode =~ ^[0-9]+$ ]]; then
    printf '%s\n' "bug(node_try_start): '$inode': invalid node id"  >&2
    return 3
  fi

  local fnode
  printf -v fnode '%s/node%03d.sh' "$QUECON_JOBDIR" "$inode"
  if system_start_node "$fnode"; then
    return 0
  fi

  # If "system_start_node" fails and no "complete.mark" is created, it implies
  # that "system_start_node" failed to start the node processing.  There are
  # two cases of "system_start_node": 1) "system_start_node" synchronously
  # calls the node processing, in which case "complete.mark" is expected to be
  # created, or 2) "system_start_node" asynchronously starts the node
  # processing, in which case "system_start_node" is expected to return exit
  # status 0.
  local fmark=${fnode%.sh}/complete.mark
  if [[ ! -s $fmark ]]; then
    printf '%s\n' '((fail++))' >> "$QUECON_JOBDIR/stat.sh"
    node_stat_var stat C
    node_stat_var time_end "$(date +%s)"
    echo 1 > "$fmark"
  fi
}

function node_all_complete {
  local inode
  for ((inode = 0; inode < QUECON_NNODE; inode++)); do
    printf -v fmark '%s/node%03d/complete.mark' "$QUECON_JOBDIR" "$inode"
    [[ -s $fmark ]] || return 1
  done
  return 0
}

#------------------------------------------------------------------------------

exec 1> "$QUECON_JOBDIR/sub.out" 2>&1

if [[ ${QUECON_NODE:-0} == 0 ]]; then
  root_stat_log 'QUECON run'
  root_stat_var node "$HOSTNAME"
  root_stat_var stat R
  root_stat_var time_start "$(date +%s)"
fi

if [[ ${QUECON_NODE-} ]]; then
  # When QUECON_NODE is assigned, we can start the corresponding node
  # processing.
  node_try_start "$QUECON_NODE"
else
  # When QUECON_NODE is unassigned, we assume that this is the leader node and
  # is supposed start the processing in the other nodes.
  for ((inode = 0; inode < QUECON_NNODE; inode++)); do
    node_try_start "$inode" &
  done
  wait
fi

if [[ ${QUECON_NODE:-0} == 0 ]]; then
  # If this is the leader node, we wait for the completion of all node scripts.
  # A node script is supposed to write "1" to the corresponding "complete.mark"
  # file on its termination.
  while ! node_all_complete; do
    sleep 1
  done

  root_stat_log 'QUECON complete'
  root_stat_var stat C
  root_stat_var time_end "$(date +%s)"
  echo 1 >> "$QUECON_JOBDIR/complete.mark"
fi
