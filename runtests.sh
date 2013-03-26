#! /bin/sh

runtest() {
  testname=$1
  cd $testname
  output="$(./runtest.sh)"
  exitstatus=$?
  if [ $exitstatus -ne 0 ]; then
    echo "================"
    echo "fail: $testname"
    echo "exitstatus: $exitstatus"
    echo "output:"
    echo "----------------"
    echo "$output"
    echo "----------------"
    return 1
  else
    return 0
  fi
}

cd tests

fail=0

for dir in *; do
  if [ ! -d "$dir" ]; then
    continue
  fi
  (runtest $dir) || fail=1
done

exit $fail
