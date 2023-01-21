#!/bin/bash
# set -u

if [[ -z $1 ]]; then
  nombre="fichero_vacio" 
else
  nombre=$1
fi
if [[ -z $2 ]]; then
  size=1024
else
  size=$2
fi
if [[ -f $nombre ]]; then
 echo "Ya existe el fichero $nombre"
  i=0
  while [[ $i -lt 10 ]]; do
   if [[ ! -f "$nombre$i" ]]; then
    dd if=/dev/zero of=$nombre$i bs=1 count=$size # si no existe un archivo con ese nombre y numero lo crea
    break # y sale del bucle
   fi
   if [[ $i -eq 9 ]]; then
    echo "No se puede crear el archivo, ya existen 9 con ese nombre" # si el contador llega a 9 no crea nada y termina el programa
   fi
   i=$((i+1))
  done 
else
  dd if=/dev/zero of=$nombre bs=1 count=$size
fi

