#!/bin/bash
set -u

if [[ -z $(ls -A /mnt/usuarios) ]]; then
 echo "/mnt/usuarios esta vacio" 
else
  # leemos cada elemento en el directorio y ejecutamos un useradd por cada uno
  while IFS= read -r usuario; do
   echo "Creando usuario $usuario ..." 
   useradd -m $usuario # Se crea el usuario con directorio home 
   # passwd $usuario
   # leemos el documento de cada usuario y por cada linea creamos una carpeta
   while IFS= read -r carpeta; do
    echo "Creando carpeta $carpeta para el usuario $usuario ..."
    mkdir /home/$usuario/$carpeta
   done < <(cat /mnt/usuarios/$usuario)
  done < <(ls /mnt/usuarios)
  echo "Hecho! No olvides asignar una contraseña para cada uno"
fi
