#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
echo stdout
echo stderr >&2
" > actual/test0.sh

chmod +x actual/test0.sh

cp -a actual expected

printf "\
================
./test0.sh
----------------
output:
  stdout
  stderr
----------------
exitstatus: 0
PASS ./test0.sh
----------------
run: 1 pass: 1 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir/test0.sh.dir/workdir

printf "\
stdout
" > expected/shutdir/test0.sh.dir/output

printf "\
stderr
" > expected/shutdir/test0.sh.dir/stderr

printf "0\n" > expected/shutdir/test0.sh.dir/exitstatus

(
  cd actual
  set +e
  shut -v -x > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
