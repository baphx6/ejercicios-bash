#!/bin/bash
set -u 

str=$(id)
if [[ "$str" == *"sudo"* || "$str" == *"wheel"* || "$str" == *"root"* ]]; then
 echo "Superusuario!" 
else
  echo "Usuario normal"
fi
