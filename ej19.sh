#!/bin/bash

# Comprobar si se ha pasado un parámetro (nombre del alumno)
if [ $# -eq 1 ]; then
  # Comprobar el total de ficheros borrados para ese alumno
  grep -c "$1" /var/log/descartados.log
  exit 0
fi

# Repositorios y extensiones válidas
repositories=("Fotografía" "Dibujo" "Imágenes")
valid_extensions=("jpg" "gif" "png")

# Recorrer cada repositorio
for repo in "${repositories[@]}"; do
  # Obtener la lista de ficheros del repositorio
  files=$(find /path/to/$repo -type f)
  # Recorrer cada fichero
  for file in $files; do
    # Obtener la extensión del fichero
    extension="${file##*.}"
    # Comprobar si la extensión es válida
    if [[ ! " ${valid_extensions[@]} " =~ " ${extension} " ]]; then
      # Comprobar el formato interno del fichero con el comando file
      file_format=$(file -i $file | awk '{print $2}' | sed 's/;//')
      # Comprobar si el formato interno es jpg, gif o png
      if [[ $file_format == "image/jpeg" || $file_format == "image/gif" || $file_format == "image/png" ]]; then
        # Renombrar la extensión al formato correcto
        new_file="${file%.*}.${file_format##*/}"
        mv $file $new_file
      else
        # Eliminar el fichero y registrar en el fichero descartados.log
        rm $file
        echo "$(date) $file $(ls -l $file | awk '{print $3, $4}')" >> /var/log/descartados.log
      fi
    fi
  done
done

# Ten en cuenta que este script asume que los repositorios de ficheros están en el directorio especificado en 
# la línea "find /path/to/$repo -type f" y que el fichero de registro de borrado se encuentra en /var/log/descartados.log.
# Si deseas, puedes añadir otro fichero de registro para registrar cambios de extensión.
