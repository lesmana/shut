#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/shutdir/existingdir

printf "\
run: 1 pass: 1 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir/test0.dir/workdir

printf "+ true\n"   > expected/shutdir/test0.dir/output
printf "0\n"        > expected/shutdir/test0.dir/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
./test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

(
  cd actual
  set +e
  shut -f > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
