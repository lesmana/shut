#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
set -x
false
" > actual/testf1.sh

printf "\
#! /bin/sh
set -x
true
" > actual/testt1.sh

printf "\
#! /bin/sh
set -x
true
" > actual/testt2.sh

chmod +x actual/testf1.sh actual/testt1.sh actual/testt2.sh

cp -a actual expected

printf "\
./testf1.sh
./testt1.sh
./testt2.sh
would run: 3
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
