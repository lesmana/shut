#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

# prepare actual

mkdir -p actual/shutdir

touch actual/shutdir/testsfound

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error deleting $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
shutdir="%s/actual/shutdir"
realrm="%s"
if [ "$*" = "-r --interactive=never -- $shutdir" ]; then
  "$realrm" "$@"
fi
"$realrm" "$@"
' "$PWD" "$(which rm)" > rm

chmod +x rm

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
