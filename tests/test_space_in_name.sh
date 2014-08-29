#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
set -x
false
" > "actual/test false 1.sh"

printf "\
#! /bin/sh
set -x
true
" > "actual/test true 1.sh"

printf "\
#! /bin/sh
set -x
true
" > "actual/test true 2.sh"

chmod +x \
      "actual/test false 1.sh" \
      "actual/test true 1.sh" \
      "actual/test true 2.sh"

cp -a actual expected

printf "\
./test false 1.sh
./test true 1.sh
./test true 2.sh
would run: 3
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
