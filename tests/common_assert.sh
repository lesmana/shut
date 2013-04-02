#! /bin/sh

assert() {
  diff -r expected actual
}
