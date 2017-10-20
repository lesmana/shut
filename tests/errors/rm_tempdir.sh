#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test1
================
found: 1 run: 0 pass: 0 fail: 0
" > expected/stdout

printf -- "\
error deleting tempdir
not fatal but annoying
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
mkdir -p -- "$PWD/tempdir"
printf -- "%%s\\n" "$PWD/tempdir"
' > mktemp

printf -- '#! /bin/sh
realrm="%s"
if [ "$*" = "-r -- $PWD/tempdir" ]; then
  "$realrm" "$@"
fi
"$realrm" "$@"
' "$(which rm)" > rm

chmod +x mktemp rm

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
