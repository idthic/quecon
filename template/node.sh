#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_TMPDIR='%%TMPDIR%%'
QUECON_NODE='%%NODE%%'
QUECON_NODEDIR='%%NODEDIR%%'
system_start_core() { builtin eval -- "$1"; }
# __QUECON_END_PARAMS__

exec 1> "$QUECON_NODEDIR/stat.out" 2>&1
node_stat_log() { echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_NODEDIR/stat.log"; }
node_stat_var() { local q=\' Q="'\''"; printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$QUECON_NODEDIR/stat.sh"; }
node_stat_log 'QUECON node.start'
node_stat_var node "$HOSTNAME"
node_stat_var stat R
node_stat_var time_start "$(date +%s)"
if [[ $QUECON_TMPDIR ]]; then
  export QUECON_TMPDIR
  if ((QUECON_NODE == 0)); then
    # The main node (node000) is responsible for the creation of the temporary
    # directory.
    if [[ ! -d $QUECON_TMPDIR ]]; then
      (umask 077; rm -rf "$QUECON_TMPDIR"; mkdir -p "$QUECON_TMPDIR")
    fi
  else
    # wait until the main node creates the temporary directory.
    while [[ ! -d $QUECON_TMPDIR ]]; do
      sleep 1
    done
  fi
fi

for fcore in "$QUECON_NODEDIR"/core[0-9]*.sh; do
  [[ -s $fcore ]] || continue
  system_start_core "$fcore" &
done
wait

[[ $QUECON_TMPDIR ]] && ((QUECON_NODE == 0)) && rm -rf "$QUECON_TMPDIR"
node_stat_log 'QUECON node.complete'
node_stat_var stat C
node_stat_var time_end "$(date +%s)"
echo 1 >> "$QUECON_NODEDIR/complete.mark"
