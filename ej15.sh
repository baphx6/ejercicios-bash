#!/bin/bash

# metemos los usuarios del sistema con directorio home en una lista
usuarios=$(ls /home)

echo "Usuarios en /home: "
echo $usuarios

# le pedimos al usuario un nombre
read -p "Elige un usuario: " usu

if [[ "$usuarios" == *"$usu"* ]]; then
 echo "Usuario valido, haciendo copia..."
 dir="/home/copiaseguridad/$usu"_$(date +%F)
 mkdir -p $dir 
 cp -r /home/$usu $dir
 echo "Copia de seguridad en: $dir"
else
  echo "Usuario no valido, prueba con uno de la lista"
fi
