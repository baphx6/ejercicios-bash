#!/bin/bash
set -u

if [[ -d $1 ]]; then
  echo "$1 es un directorio"
elif [[ -L $1 ]]; then
  echo "$1 es un symlink"
else
  echo "$1 es un fichero"
fi
echo $(df -H $1 | awk '{print $6}')
if [[ -z "$(ls -A $1)" ]]; then
 echo "$1 está vacio"
else 
  echo "Numero de inodos: $(ls -lis $1 | awk '{print $1}')"
  echo "Tamaño: $(ls -lis $1 | awk '{print $2}')"
fi
