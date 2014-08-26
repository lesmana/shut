#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
set -x
false
" > actual/prefix_false1.sh

printf "\
#! /bin/sh
set -x
true
" > actual/prefix_true1.sh

printf "\
#! /bin/sh
set -x
true
" > actual/prefix_true2.sh

chmod +x \
      actual/prefix_false1.sh \
      actual/prefix_true1.sh \
      actual/prefix_true2.sh

cp -a actual expected

printf "\
./prefix_false1.sh
./prefix_true1.sh
./prefix_true2.sh
would run: 3
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir

(
  cd actual
  set +e
  shut -n prefix > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
