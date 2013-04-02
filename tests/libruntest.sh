#! /bin/sh

before_arrange() { :; }

arrange() {
  rm -rf expected
  rm -rf actual

  cp -a stage actual
  cp -a stage expected

  (cd effect; tar cf - .) | (cd expected; tar xf -)
}

after_arrange() { :; }

before_act() { :; }

shutcommand_in_actual() {
  echo "you did not redefine shutcommand"
  echo "you lost the game"
  exit 22
}

act() {
  (
    cd actual
    set +x
    shutcommand_in_actual > output 2>&1
    echo $? > exitstatus
  )
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
  exitstatus=$?
  after_assert $exitstatus
  return $exitstatus
}
