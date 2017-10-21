#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
true
" > actual/test1

chmod +x actual/test1

touch actual/shutdir

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
is not directory: shutdir
will not overwrite
" > expected/stderr

printf -- "\
2
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
