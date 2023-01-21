#!/bin/bash
set -u

echo "Buscando..."
find -type f -name $1

num_vocales=$(cat $1 | grep -Eo '[aAeEiIoOuU]' | wc -l)

echo "El numero de vocales en $1 es: $num_vocales"
