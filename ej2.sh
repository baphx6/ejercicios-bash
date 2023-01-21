#!/bin/bash
set -u

# Un año es bisiesto si es divisible por 4
if [[ $(($1%4))==0 ]]; then
  echo "$1 es bisiesto"
else
  echo "$1 no es bisiesto"
fi
