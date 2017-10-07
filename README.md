command line tool black box test (cltbbt)
--------------------------------

a tool to help black box testing command line tools.

black box test means we do not know how the command line tool is implemented.
we only test the side effects of the command line tool.

command line tool means more or less the following:

* takes arguments
* read from stdin
* read from files or directories
* read from environment variables
* write to stdout or stderr
* write, create, or delete files or directories
* returns exit status

cltbbt does not test the command line tool directly.
you have to write the tests in form of executables that returns
exit status 0 for success and exit status other than 0 for fail.
optionally print messages which help to determine what went wrong.

cltbbt will then execute the tests and print a nice summary.
if some tests failed also print the messages from the tests.
