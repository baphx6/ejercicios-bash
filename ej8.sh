#!/bin/bash
set -u

read -p "Escribe el directorio (a poder ser la ruta entera): " dir
if [[ ! -d $dir ]]; then
 echo "Eso no es un directorio!" 
else
  if [[ -z $(ls -A $dir) ]]; then
    echo "$dir esta vacio" 
  else
    echo "$dir tiene $(ls $dir | wc -l) elementos dentro"
  fi
fi
