#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error copying testsfound to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
shutdir="%s/actual/shutdir"
realcp="%s"
if [ "$*" = "-- testsfound $shutdir" ]; then
  mkdir -- "$shutdir/testsfound"
  "$realcp" "$@"
  exitstatus=$?
  rm -r -- "$shutdir/testsfound"
  exit $exitstatus
else
  "$realcp" "$@"
fi
' "$PWD" "$(which cp)" > cp

chmod +x cp

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r expected actual
