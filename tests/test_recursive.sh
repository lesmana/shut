#! /bin/sh

set -xeu

mkdir -p actual/subdir1 actual/subdir2/subdir21

printf "\
#! /bin/sh
set -x
true
" > actual/test0

printf "\
#! /bin/sh
set -x
true
" > actual/subdir1/test1

printf "\
#! /bin/sh
set -x
true
" > actual/subdir2/test2

printf "\
#! /bin/sh
set -x
true
" > actual/subdir2/subdir21/test21

chmod +x \
      actual/test0 \
      actual/subdir1/test1 \
      actual/subdir2/test2 \
      actual/subdir2/subdir21/test21

cp -a actual expected

printf "\
./subdir1/test1
./subdir2/subdir21/test21
./subdir2/test2
./test0
would run: 4
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir expected/shutdir

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
