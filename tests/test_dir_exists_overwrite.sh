#! /bin/sh

set -xeu

mkdir -p actual actual/logdir

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/logdir/existinglogdir

printf "\
run: 1 pass: 1 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/logdir/test0.dir/workdir

printf "+ true\n"   > expected/logdir/test0.dir/output
printf "0\n"        > expected/logdir/test0.dir/exitstatus

(
  cd actual
  set +e
  shut -d logdir -f > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
