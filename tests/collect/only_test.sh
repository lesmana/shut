#! /bin/sh

set -xeu

mkdir -p actual/testdir actual/xtestdir

touch \
      actual/test0 \
      actual/test1 \
      actual/nottest \
      actual/testdir/test0 \
      actual/testdir/test1 \
      actual/testdir/nottest \
      actual/xtestdir/test0 \
      actual/xtestdir/test1 \
      actual/xtestdir/nottest

chmod +x \
      actual/test0 \
      actual/test1 \
      actual/nottest \
      actual/testdir/test0 \
      actual/testdir/test1 \
      actual/testdir/nottest \
      actual/xtestdir/test0 \
      actual/xtestdir/test1 \
      actual/xtestdir/nottest

cp -a actual expected

printf -- "\
./test0
./test1
./testdir/test0
./testdir/test1
./xtestdir/test0
./xtestdir/test1
================
would run: 6
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "0\n" > expected/exitstatus

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
