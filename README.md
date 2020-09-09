# quecon

`quecon` provides an interface to submit massive number of independent Monte-Carlo calculations to job schedulers.
This is originally desigined for event-by-event simulations of high-energy nuclear collisions which typically include thousands and millions of independent events.
Named after *job-queue controller*.

```
quecon SUBCMD ...
```

## 1. quecon stat

```
quecon [stat] [OPTIONS...]
quecon [stat] JOB_INDEX [TYPE] [OPTIONS...]
```

### TYPE

- `log` (default)
- `out`, `tail`
- `ls`
- `sub.sh`, `cmd.sh`, `job*.sh`, `stat*.sh`

## 2. quecon submit

```
quecon submit [-ct | -r RANGE] COMMAND
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

  Use temporary directory `QUECON_TMPDIR`.  The directory will be
  deleted on the job completion.

- `-r, --repeat=[REP=][BEGIN:]END[/NNODE[xNCORE]]`

  Repeat commands for `QUECON_INDEX` in `[BEGIN, END)` using
  `NNODExNCORE` parallel jobs.  The default value for `BEGIN` is 0.
  The default value for `NPROC` is 1.  When `REP` is specified, the
  matching string in `COMMAND` is replaced by the value of
  `QUECON_INDEX`.
