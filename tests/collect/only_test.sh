#! /bin/sh

set -xeu

# prepare actual

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

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test0
./test1
./testdir/test0
./testdir/test1
./xtestdir/test0
./xtestdir/test1
================
found: 6
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
) || true

# compare

diff ${SHUT_VERBOSE+"-u"} -r expected actual
