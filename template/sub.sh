#!/usr/bin/env bash
QUECON_JOBDIR='%%JOBDIR%%'
QUECON_TMPDIR='%%TMPDIR%%'
start_thread() { srun -n 1 "$1"; }

exec 1> "$QUECON_JOBDIR/sub.out" 2>&1
print_log() { echo "[$(date +"%F %T %Z")] $1" >> "$QUECON_JOBDIR/stat.log"; }
print_var() { local q=\' Q="'\''"; printf "%s='%s'\n" "$1" "${2//$q/$Q}" >> "$QUECON_JOBDIR/stat.sh"; }
print_log 'QUECON run' 
print_var node "$HOSTNAME"
print_var stat R
print_var time_start "$(date +%s)"
if [[ $QUECON_TMPDIR ]]; then
  export QUECON_TMPDIR
  [[ -d $QUECON_TMPDIR ]] ||
    (umask 077; rm -rf "$QUECON_TMPDIR"; mkdir -p "$QUECON_TMPDIR")
fi
for jobsh in "$QUECON_JOBDIR"/job*.sh; do
  [[ -s $jobsh ]] || continue
  start_thread "$jobsh" &
done
wait
[[ $QUECON_TMPDIR ]] && rm -rf "$QUECON_TMPDIR"
print_log 'QUECON complete'
print_var stat C
print_var time_end "$(date +%s)"
echo 1 >> "$QUECON_JOBDIR/complete.mark" 
