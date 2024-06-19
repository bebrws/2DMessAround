#!/bin/sh
echo -ne '\033c\033]0;2DMessAround\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Linux2DMessAround.x86_64" "$@"
