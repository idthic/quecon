#!/usr/bin/env bash
IDTSUB_JOBDIR='%%JOBDIR%%'
IDTSUB_COMMAND='%%COMMAND%%'
IDTSUB_REPLACE='%%REPLACE%%'
IDTSUB_PWD='%%PWD%%'
IDTSUB_HOME='%%HOME%%'

print_log() { echo "[$(date +"%F %T %Z")] $1" >> "$IDTSUB_JOBDIR/stat.log"; }
print_var() { local q=\' Q="'\''"; printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$IDTSUB_JOBDIR/stat.sh"; }

HOME=$IDTSUB_HOME
cd "$HOME"
. .bashrc
cd "$IDTSUB_PWD"

export PATH=$IDTSUB_JOBDIR/bin:$PATH
export IDTSUB_INDEX
for IDTSUB_INDEX in {%%MIN%%..%%MAX%%}; do
  _idtsub_command=$IDTSUB_COMMAND
  [[ $IDTSUB_REPLACE ]] &&
    _idtsub_command=${IDTSUB_COMMAND//$IDTSUB_REPLACE/$IDTSUB_INDEX}
  print_log "${_idtsub_command/#$IDTSUB_JOBDIR/.}"
  print_var stat "R$((IDTSUB_INDEX-%%MIN%%+1))/%%COUNT%%"
  eval "$_idtsub_command" ||
    echo '((fail++))' >> "$IDTSUB_JOBDIR/stat.sh"
done
