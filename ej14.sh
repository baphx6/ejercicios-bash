#!/bin/bash
set -u

# str=$1
# echo $str
# str=${str//a/1}
# str=${str//e/2}
# str=${str//i/3}
# str=${str//o/4}
# str=${str//u/5}
# echo $str
echo $1 | tr 'aeiou' '12345'
