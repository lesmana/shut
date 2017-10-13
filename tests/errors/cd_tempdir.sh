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
failed changing directory to $PWD/actual/loldir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
touch -- "$PWD/loldir"
printf -- "%%s\\n" "$PWD/loldir"
' > mktemp

chmod +x mktemp

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
