#! /bin/sh

# prepare actual

mkdir -p actual/testdir actual/xtestdir

touch \
  actual/test1 \
  actual/test2 \
  actual/nottest \
  actual/testdir/test1 \
  actual/testdir/test2 \
  actual/testdir/nottest \
  actual/xtestdir/test1 \
  actual/xtestdir/test2 \
  actual/xtestdir/nottest

chmod +x \
  actual/test1 \
  actual/test2 \
  actual/nottest \
  actual/testdir/test1 \
  actual/testdir/test2 \
  actual/testdir/nottest \
  actual/xtestdir/test1 \
  actual/xtestdir/test2 \
  actual/xtestdir/nottest

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test1
./test2
./testdir/test1
./testdir/test2
./xtestdir/test1
./xtestdir/test2
================
found: 6 run: 0 pass: 0 fail: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
