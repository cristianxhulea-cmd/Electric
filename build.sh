#!/bin/sh
set -e
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="ro">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n</head>\n<body>\n'
  cat electroplan.html
  printf '\n</body>\n</html>\n'
} > index.html
