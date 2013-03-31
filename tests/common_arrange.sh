#! /bin/sh

(test -d effect && test -d stage) ||
      { echo "need effect and stage"; exit 1; }

test -e expected && rm -rf expected
test -e actual && rm -rf actual

cp -a stage actual
cp -a stage expected

(cd effect; tar cf - .) | (cd expected; tar xf -)

test -x arrange.sh && ./arrange.sh
