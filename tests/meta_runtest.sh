#! /bin/sh

. ./sourceme.sh

: ${expectedoutput?}
: ${expectedexitstatus?}
: ${buttcommand?}

output="$($buttcommand 2>&1)"
exitstatus=$?

fail=0

if [ "$output" != "$expectedoutput" ]; then
  fail=1
  echo "output do not match"
  echo "expected/actual output:"
  echo "----"
  echo "$expectedoutput"
  echo "----"
  echo "$output"
  echo "----"
fi

if [ "$exitstatus" != "$expectedexitstatus" ]; then
  fail=1
  echo "exit status do not match"
  echo "expected: $expectedexitstatus actual: $exitstatus"
fi

exit $fail