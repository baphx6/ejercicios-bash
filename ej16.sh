#!/bin/bash

read -p "Cuantos alumnos hay? " num_alu

# declaramos los contadores de aprobados y suspensos
aprobados=0
suspensos=0
# declaramos la suma de las notas como int
declare -i sum_notas=0
for ((i = 1; i <= $num_alu; i++)); do
  read -p "Nombre de alumno $i: " alu
  read -p "Nota de $alu: " nota
  sum_notas+=$(($nota))
  if [[ $nota -lt 5 ]]; then
    ((suspensos++)) 
  else
    ((aprobados++))
  fi
done

echo "Numero de suspensos: $suspensos"
echo "Numero de aprobados: $aprobados"
media=$(($sum_notas/$num_alu))
echo "Nota media de la clase: $media"
echo "Ten en cuenta que bash no trata numeros enteros, asi que se redondea el resultado"
