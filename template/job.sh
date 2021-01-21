#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_COMMAND='%%COMMAND%%'
QUECON_REPNODE='%%NODE%%'
QUECON_REPBEG='%%BEG%%'
QUECON_REPEND='%%END%%'
QUECON_REPSTEP='%%STEP%%'
QUECON_REPLACE='%%REPLACE%%'
QUECON_PWD='%%PWD%%'
QUECON_HOME='%%HOME%%'

_quecon_statfile=$QUECON_JOBDIR/stat$QUECON_REPNODE.sh
print_log() { echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_JOBDIR/stat.log"; }

HOME=$QUECON_HOME
cd "$HOME"
. .bashrc
cd "$QUECON_PWD"

export PATH=$QUECON_JOBDIR/bin:$PATH
export QUECON_INDEX
for ((QUECON_INDEX=QUECON_REPBEG;QUECON_INDEX<QUECON_REPEND;QUECON_INDEX+=QUECON_REPSTEP)); do
  _quecon_command=$QUECON_COMMAND
  [[ $QUECON_REPLACE ]] &&
    _quecon_command=${QUECON_COMMAND//$QUECON_REPLACE/$QUECON_INDEX}
  print_log "${_quecon_command/#$QUECON_JOBDIR/.}"
  eval "$_quecon_command" || echo '((fail++))' >> "$_quecon_statfile"
  echo '((done++))' >> "$_quecon_statfile"
done
