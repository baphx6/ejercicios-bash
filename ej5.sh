#!/bin/bash
set -u

if [[ (($1 -lt 3)) ]]; then
  echo "niñez"
elif [[ (($1 -lt 10 && $1 -ge 3)) ]]; then
  echo "infancia"
elif [[ (($1 -lt 18 && $1 -ge 10)) ]]; then
  echo "adolescencia"
elif [[ (($1 -lt 40 && $1 -ge 18)) ]]; then
  echo "juventud"
elif [[ (($1 -lt 65 && $1 -ge 40)) ]]; then
  echo "madurez"
elif [[ (($1 -gt 65)) ]]; then
  echo "vejez"
fi

