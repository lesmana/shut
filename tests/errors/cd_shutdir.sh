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
realcp="%s"
if [ "$*" = "-- testsfound $shutdir" ]; then
  rm -rf -- "$shutdir"
else
  "$realcp" "$@"
fi
' "$PWD" "$(which cp)" > cp

chmod +x cp

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
