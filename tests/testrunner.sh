#! /bin/sh

(test -d effect && test -d stage) ||
      { echo "need effect and stage"; exit 1; }

test -e expected && rm -rf expected
test -e actual && rm -rf actual

mkdir expected
mkdir actual

(cd effect; tar cf - .) | (cd expected; tar xf -)
(cd stage; tar cf - .) | (cd expected; tar xf -)

(cd stage; tar cf - .) | (cd actual; tar xf -)

(cd actual; ../buttcommand.sh > output 2>&1; echo $? > exitstatus)

diff -r expected actual
