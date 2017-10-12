#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test_exec actual/test_notexec

chmod +x actual/test_exec

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test_exec
================
found: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff ${SHUT_VERBOSE+"-u"} -r expected actual
