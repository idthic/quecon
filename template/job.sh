#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_COMMAND='%%COMMAND%%'
QUECON_REPLACE='%%REPLACE%%'
QUECON_PWD='%%PWD%%'
QUECON_HOME='%%HOME%%'

print_log() { echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_JOBDIR/stat.log"; }
print_var() { local q=\' Q="'\''"; printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$QUECON_JOBDIR/stat.sh"; }

HOME=$QUECON_HOME
cd "$HOME"
. .bashrc
cd "$QUECON_PWD"

export PATH=$QUECON_JOBDIR/bin:$PATH
export QUECON_INDEX
for QUECON_INDEX in {%%MIN%%..%%MAX%%}; do
  _quecon_command=$QUECON_COMMAND
  [[ $QUECON_REPLACE ]] &&
    _quecon_command=${QUECON_COMMAND//$QUECON_REPLACE/$QUECON_INDEX}
  print_log "${_quecon_command/#$QUECON_JOBDIR/.}"
  print_var stat "R$((QUECON_INDEX-%%MIN%%+1))/%%COUNT%%"
  eval "$_quecon_command" ||
    echo '((fail++))' >> "$QUECON_JOBDIR/stat.sh"
done
