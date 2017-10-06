#! /bin/dash

PATH=$PWD:$PATH

tests=tests

for arg in "$@"; do
  if [ -e "$arg" ]; then
    tests=
  fi
done

goodshut "$@" "$tests"
