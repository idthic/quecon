# idtsub

Job scheduler interface

```
idtsub SUBCMD ...
```

## 1. idtsub submit

```
idtsub submit [-ct | -r RANGE] COMMAND
```

### Options

- `--system JOB_SYSTEM`

  Select a underlying job system.  One of `slurm` or `direct`.

- `-c, --copy`

  Copy the command file to protect against possible changes to the
  file after submission.  This is useful when one wants to edit the
  submitted script after the submission.

- `-C, --copy-binary=BIN`

  Copy the binary found in `PATH` to the job local directory and
  prepend the directory to `PATH`.

- `-t, --create-tmpdir`

  Use temporary directory `IDTSUB_TMPDIR`.  The directory will be
  deleted on the job completion.

- `-r, --repeat=[REP=][BEGIN:]END[/NPROC]`

  Repeat commands for `IDTSUB_INDEX` in `[BEGIN, END)` using `NPROC`
  parallel jobs.  The default value for `BEGIN` is 0.  The default
  value for `NPROC` is 1.  When `REP` is specified, the matching
  string in `COMMAND` is replaced by the value of `IDTSUB_INDEX`.

## 2. idtsub stat

```
idtsub [stat] [OPTIONS...]
idtsub stat JOB_INDEX [TYPE] [OPTIONS...]
```

### TYPE

- `log` (default)
- `out`
- `ls`
- `stat.sh`, `sub.sh`, `job.sh`, `cmd.sh`
