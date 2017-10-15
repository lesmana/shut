#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test1

# prepare shutdir

printf -- "\
./test1
" > expected/shutdir/testsfound

printf -- "\
./test1
" > expected/shutdir/testsrun

printf -- "\
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
ERROR ./test1
" > expected/stdout

printf -- "\
error changing directory to workdir
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
realmkdir="%s"
if [ "$*" != "workdir" ]; then
  "$realmkdir" "$@"
fi
' "$(which mkdir)" > mkdir

chmod +x mkdir

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
