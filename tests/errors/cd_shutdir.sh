#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error changing directory to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
shutdir="%s/actual/shutdir"
realmkdir="%s"
if [ "$*" != "-p -- $shutdir" ]; then
  "$realmkdir" "$@"
fi
' "$PWD" "$(which mkdir)" > mkdir

chmod +x mkdir

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
