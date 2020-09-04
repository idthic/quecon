# `idtsub`

## Usage

```
idtsub [OPTIONS] COMMAND
```

## Options

- `-c`

  Copy the command file to protect against possible changes to the
  file after submission.  This is useful when one wants to edit the
  submitted script after the submission.

- `-t`

  Use temporary directory `IDTSUB_TMPDIR`.  The directory will be
  deleted on the job completion.

- `-r [REP=][BEGIN:]END[/NPROC]`

  Repeat commands for `IDTSUB_INDEX` in `[BEGIN, END)` using `NPROC`
  parallel jobs.  The default value for `BEGIN` is 0.  The default
  value for `NPROC` is 1.  When `REP` is specified, the matching
  string in `COMMAND` is replaced by the value of `IDTSUB_INDEX`.
