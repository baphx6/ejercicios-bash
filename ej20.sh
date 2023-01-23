#!/bin/bash

# Comprobar que se ha pasado únicamente un parámetro
if [ $# -ne 1 ]; then
  echo "Error: se debe pasar únicamente un parámetro (nombre del archivo de usuarios a dar de baja)"
  exit 1
fi

# Comprobar que el parámetro es un archivo existente
if [ ! -f $1 ]; then
  echo "Error: el parámetro debe ser un archivo existente"
  exit 1
fi

# Leer cada línea del archivo y procesar cada usuario
while IFS=':' read -r name lastname secondlastname login; do
  # Comprobar si el usuario existe en el sistema
  if id $login > /dev/null 2>&1; then
    # Crear carpeta con el login del usuario en /home/proyecto/
    mkdir /home/proyecto/$login
    # Mover los ficheros del directorio trabajo a la nueva carpeta
    mv /home/$login/trabajo/* /home/proyecto/$login/
    # Registrar en el fichero de log bajas.log
    echo "$(date) $login $name $lastname $secondlastname" >> /var/log/bajas.log
    # Cambiar el propietario de los ficheros a root
    chown -R root:root /home/proyecto/$login
    # Borrar el usuario del sistema y sus ficheros personales
    userdel $login
    rm -r /home/$login
  else
    # Registrar en el fichero de log bajaserror.log
    echo "$(date) $login $name $lastname $secondlastname Usuario no existe en el sistema" >> /var/log/bajaserror.log
  fi
done < $1
