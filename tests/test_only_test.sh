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

printf "\
./test0
./test1
./testdir/test0
./testdir/test1
./xtestdir/test0
./xtestdir/test1
would run: 6
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
