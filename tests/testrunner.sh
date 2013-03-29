#! /bin/sh

(test -d effect && test -d stage) ||
      { echo "need effect and stage"; exit 1; }

test -e expected && rm -rf expected
test -e actual && rm -rf actual

cp -a stage actual
cp -a stage expected

(cd effect; tar cf - .) | (cd expected; tar xf -)

(cd actual; ../buttcommand.sh > output 2>&1; echo $? > exitstatus)

diff -r expected actual
