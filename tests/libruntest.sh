#! /bin/sh

before_arrange() { :; }

arrange() {
  test -e expected && rm -rf expected
  test -e actual && rm -rf actual

  cp -a stage actual
  cp -a stage expected

  (cd effect; tar cf - .) | (cd expected; tar xf -)
}

after_arrange() { :; }

before_act() { :; }

act() {
  (cd actual; ../shutcommand.sh > output 2>&1; echo $? > exitstatus)
}

after_act() { :; }

before_assert() { :; }

assert() {
  diff -r expected actual
}

after_assert() { :; }

runtest() {
  before_arrange
  arrange
  after_arrange
  before_act
  act
  after_act
  before_assert
  assert
  after_assert
}
