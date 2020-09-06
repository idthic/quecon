#!/usr/bin/env bash

function is-function { declare -f "$1" &>/dev/null; }
function v { [[ $VERBOSE ]] && echo "$*"; "$@"; }

function mkd { while (($#)); do [[ -d $1 ]] || v mkdir -p "$1"; shift; done; }
function mkpd { while (($#)); do [[ $1 != ?*/* ]] || mkd "${1%/*}"; shift; done; }

function cmd:install {
  local src=$1 dst=$2
  [[ $VERBOSE ]] || echo "INS $src"
  mkpd "$dst"
  v cp "$src" "$dst"
}

if is-function "cmd:$1"; then
  "cmd:$@"
else
  echo "mktool: unknown subcommand '$1'" >&2
  exit 2
fi
