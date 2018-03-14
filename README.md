shut
----

shut helps you to black box test command line tools

black box test means, for the sake of testing,
we do not know how the command line tool is implemented.
we only know what goes in and what comes out.
and the side effects.

command line tool is an executable that does the following:

* invoked with some or no arguments
* may read from stdin
* may read from files or directories
* may read from environment variables
* may change, create, or delete files or directories
* may write to stdout or stderr
* returns exit status

shut does not test the command line tool directly.
you have to write the tests in form of executables that returns
exit status 0 for success and exit status other than 0 for fail.
optionally print messages which help to determine what went wrong.

shut will then execute the tests and print a nice summary.
if some tests failed also print the messages from the tests.
