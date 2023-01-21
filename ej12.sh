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

# dd coge /dev/zero como input file (if) 
# y escribe ceros en la output file (of) nombre
# con un tamaño de size bytes
# bs (byte size) esta a 1 para que trabaje con Bytes
dd if=/dev/zero of=$nombre bs=1 count=$size
#########################################
####### MEJORABLE CON FALLOCATE #########
#########################################
