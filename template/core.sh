#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_NODEDIR='%%NODEDIR%%'
QUECON_COMMAND='%%COMMAND%%'
QUECON_REPNODE='%%NODE%%'
QUECON_REPCORE='%%CORE%%'
QUECON_REPBEG='%%BEG%%'
QUECON_REPEND='%%END%%'
QUECON_REPSTEP='%%STEP%%'
QUECON_REPLACE='%%REPLACE%%'
QUECON_PWD='%%PWD%%'
QUECON_HOME='%%HOME%%'
# __QUECON_END_PARAMS__

core_stat_log() { echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_NODEDIR/stat.log"; }

# Note: We originally wrote those counting to a file specific to this core, to
# avoid broken Bash syntax, in the format ((fail++)) and ((done++)) to allow
# sourcing the count file later.  However, creating a file for each core ends
# up thousands of files, which then leads to a long delay for the "quecon stat"
# request.  We instead decided to switch to read the count files using AWK with
# a simpler format, which is safe for the file-contents breakage by the race
# condition.
printf -v _quecon_node_count '%s/count.txt' "$QUECON_NODEDIR"
core_inc_fail() { printf 'fail\n' >> "$_quecon_node_count"; }
core_inc_done() { printf 'done\n' >> "$_quecon_node_count"; }

HOME=$QUECON_HOME
cd "$HOME" || { core_inc_fail; return 1 2>/dev/null || exit 1; }
. .bashrc
cd "$QUECON_PWD" || { core_inc_fail; return 1 2>/dev/null || exit 1; }

export PATH=$QUECON_JOBDIR/bin:$PATH
export QUECON_INDEX
for ((QUECON_INDEX=QUECON_REPBEG;QUECON_INDEX<QUECON_REPEND;QUECON_INDEX+=QUECON_REPSTEP)); do
  _quecon_command=$QUECON_COMMAND
  [[ $QUECON_REPLACE ]] &&
    _quecon_command=${QUECON_COMMAND//$QUECON_REPLACE/$QUECON_INDEX}
  core_stat_log "${_quecon_command/#$QUECON_JOBDIR/.}"
  eval -- "$_quecon_command" || core_inc_fail
  core_inc_done
done
