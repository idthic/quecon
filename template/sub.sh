#!/usr/bin/env bash
IDTSUB_JOBDIR='%%JOBDIR%%'
IDTSUB_TMPDIR='%%TMPDIR%%'
start_thread() { srun -n 1 "$1"; }

exec 1> "$IDTSUB_JOBDIR/sub.out" 2>&1
print_log() { echo "[$(date +"%F %T %Z")] $1" >> "$IDTSUB_JOBDIR/stat.log"; }
print_var() { local q=\' Q="'\''"; printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$IDTSUB_JOBDIR/stat.sh"; }
print_log 'IDTSUB run' 
print_var node "$HOSTNAME"
print_var stat R
print_var time_start "$(date +%s)"
if [[ $IDTSUB_TMPDIR ]]; then
  export IDTSUB_TMPDIR
  [[ -d $IDTSUB_TMPDIR ]] ||
    (umask 077; rm -rf "$IDTSUB_TMPDIR"; mkdir -p "$IDTSUB_TMPDIR")
fi
start_thread "$IDTSUB_JOBDIR/job.sh"
[[ $IDTSUB_TMPDIR ]] && rm -rf "$IDTSUB_TMPDIR"
print_log 'IDTSUB complete'
print_var stat C
print_var time_end "$(date +%s)"
echo 1 >> "$IDTSUB_JOBDIR/complete.mark" 
