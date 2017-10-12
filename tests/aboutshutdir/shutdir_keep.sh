#! /bin/sh

# prepare actual

mkdir -p actual/shutdir

printf -- "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

touch actual/shutdir/existingdir

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
name exists: shutdir
will not overwrite
" > expected/stderr

printf -- "\
2
" > expected/exitstatus

# run shut

(
  cd actual
  shut -k > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff ${SHUT_VERBOSE+"-u"} -r expected actual
