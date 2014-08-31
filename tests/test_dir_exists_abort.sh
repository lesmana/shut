#! /bin/sh

set -xeu

mkdir -p actual actual/logdir

touch actual/logdir/existinglogdir

cp -a actual expected

printf "\
name exists: logdir
will not overwrite
use -f to overwrite
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -d logdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
