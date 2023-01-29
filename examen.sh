#!/bin/bash
set -u

function factorial {
  num=$1
  factorial=1
  for (( i=1; i<=$num; i++ )); do
    factorial=$(($factorial*$i))
  done
  echo "!$num=$factorial"
}

function bisiesto {
  if (( $1 % 4 == 0 )) && (( $1 % 100 != 0 )) || (( $1 % 400 == 0 )); then
  # un año es bisiesto cuando es divisible por 4 pero no por 100
  # o si es divisible por 400
    echo "$1 es bisiesto"
  else
    echo "$1 no es bisiesto"
  fi
}

function configurarred {
  # Escribimos en el yaml del netplan
  echo 
"
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [$1/$2] # IP/MASK
      routes:
        - to: default
          via: $3 #GATEWAY
      nameservers:
        addresses: [$4]
  version: 2
  renderer: NetworkManager
" > /etc/netplan/01-network-manager-all.yaml
  # Y aplicamos los cambios
  netplan apply
}

function adivina {
  random=$(( (RANDOM % 100) + 1 )) # se crea un numero aleatorio entre 1 y 100
  intentos=0 # y el contador de intentos
  exit=0
  while [ $exit != 1 ]; do
    read -p "Prueba un numero: " guess # le preguntamos al usuario un numero
    ((intentos++)) # se le suma uno al contador
    if [[ $guess -eq $random ]]; then
      echo "Felicidades! Has acertado en $intentos intentos."
      ((exit++)) # Si acierta se acaba el bucle
    elif [[ $guess -lt $random ]]; then
      echo "Fallaste! El numero es mayor que $guess"
    else
      echo "Fallaste! El numero es menor que $guess"
    fi
  done
}

function edad {
  if [[ (($1 -lt 3)) ]]; then
    echo "niñez"
  elif [[ (($1 -lt 10 && $1 -ge 3)) ]]; then
    echo "infancia"
  elif [[ (($1 -lt 18 && $1 -ge 10)) ]]; then
    echo "adolescencia"
  elif [[ (($1 -lt 40 && $1 -ge 18)) ]]; then
    echo "juventud"
  elif [[ (($1 -lt 65 && $1 -ge 40)) ]]; then
    echo "madurez"
  elif [[ (($1 -gt 65)) ]]; then
    echo "vejez"
  fi
}

function fichero {
  # Revisamos el tipo de fichero
  if [[ -d $1 ]]; then
    echo "$1 es un directorio"
  elif [[ -L $1 ]]; then
    echo "$1 es un symlink"
  elif [[ -f $1 ]]; then
    echo "$1 es un fichero"
  else
    echo "$1 no existe"
    return
  fi
  # Mostramos donde se ha montado
  echo $(df -H $1 | awk '{print $6}')
  # Comprobamos si esta vacio
  if [[ -z "$(ls -A $1)" ]]; then
   echo "$1 está vacio"
  else # Y si no mostramos los inodos y el tamaño
    echo "Numero de inodos: $(ls -lis $1 | awk '{print $1}')"
    echo "Tamaño: $(ls -lish $1 | awk '{print $2}')"
  fi
}

function buscar {
  echo "Buscando..."
  # Buscamos el archivo con find -type f -name
  find -type f -name $1
  
  # Mostramos el contenido del archivo, filtramos las vocales y las contamos
  num_vocales=$(cat $1 | grep -Eo '[aAeEiIoOuU]' | wc -l)

  echo "El numero de vocales en $1 es: $num_vocales"
}

function contar {
  if [[ ! -d $1 ]]; then
    echo "$1 no existe"
  elif [[ -z $1 ]] ; then
    echo "$1 esta vacio"
  else
    # Se comprueba que el directorio existe y no esta vacio, luego se cuenta con ls y wc
    cont=$(ls -l $1 | wc -l)
    echo "$1 tiene $cont elementos dentro"
  fi
}

function privilegios {
  if [[ "$(id)" == *"root"* || "$(id)" == *"sudo"* || "$(id)" == *"wheel"* ]]; then
    echo "$(whoami), eres superusuario!"
  else
    echo "$(whoami), eres un usuario normal"
  fi
}

function romano {
    
    if [[ $1 -lt 1 || $1 -gt 200 ]]; then
      echo "Tiene que estar entre 1 y 200"
      return
    fi
    
    num=$1
    roman=""

    while [ $num -ge 100 ]
    do
        roman+="C"
        num=$((num-100))
    done

    while [ $num -ge 90 ]
    do
        roman+="XC"
        num=$((num-90))
    done

    while [ $num -ge 50 ]
    do
        roman+="L"
        num=$((num-50))
    done

    while [ $num -ge 40 ]
    do
        roman+="XL"
        num=$((num-40))
    done

    while [ $num -ge 10 ]
    do
        roman+="X"
        num=$((num-10))
    done

    while [ $num -ge 9 ]
    do
        roman+="IX"
        num=$((num-9))
    done

    while [ $num -ge 5 ]
    do
        roman+="V"
        num=$((num-5))
    done

    while [ $num -ge 4 ]
    do
        roman+="IV"
        num=$((num-4))
    done

    while [ $num -ge 1 ]
    do
        roman+="I"
        num=$((num-1))
    done

    echo $roman
}

function automatizar {

  if [[ ! -d /mnt/usuarios ]]; then
    echo "El directorio /mnt/usuarios no existe"
  elif [[ -z $(ls /mnt/usuarios) ]]; then
    echo "El directorio /mnt/usuarios esta vacio" # Comprobamos que el directorio existe y no esta vacio
  else
    while IFS= read -r usuario; do # Leemos el contenido del directorio y hacemos un useradd -m para cada archivo
      echo "Creando a $usuario..."
      useradd -m $usuario
      while IFS= read -r carpeta; do # Leemos el contenido de cada archivo y creamos una carpeta por cada linea en el
        echo "Creando carpeta $carpeta en el home de $usuario..."
        mkdir /home/$usuario/$carpeta
      done < <(cat /mnt/usuarios/$usuario)
    done < <(ls /mnt/usuarios)
  fi
  echo "Hecho! No olvides ponerle contraseña a cada uno"

}

function crear {
  name=${1:-fichero_vacio} # con esta sintaxis se comprueba si el valor de $1 es null
  size=${2:-1024}          # si lo fuese se asigna el valor despues de :- a la variable name/size

  fallocate -l "${size}K" "${name}"
  echo "Hecho!"
}

function crear_2 {
  name=${1:-fichero_vacio} # con esta sintaxis se comprueba si el valor de $1 es null
  size=${2:-1024}          # si lo fuese se asgina el valor despues de :- a la variable name/size
  
  if [[ -f $name ]]; then # si el archivo ya existe entra al for
    echo "Ya existe el archivo $name"
    for (( i=0; i<10; i++ )); do
      if [[ ! -f "$name$i" ]]; then # si el archivo con ese numero no existe lo crea y sale de la funcion
        echo "Creando archivo $name$i..."
        fallocate -l "${size}K" "$name$i"
        echo "Hecho!"
        return
      fi
    done
    # si llega aqui significa que llego al fin del bucle y no creo nada
    echo "Ya existen 10 archivos con ese nombre, no se puede crear uno nuevo"
  else
    fallocate -l "${size}K" "${name}"
  fi
  echo "Hecho!"
}

function reescribir {
  echo $1 | tr 'aeiouAEIOU ' '1234512345_'
}

function contusu {
  usuarios=$(ls /home) # metemos los usuarios con directorio home en una variable
  echo "Usuarios en /home: "
  echo $usuarios
  
  read -p "Elige un usuario: " usu
  if [[ "$usuarios" == *"$usu"* ]]; then # si el usuario elegido esta en la lista
    echo "Usuario valido, haciendo copia..."
    dir="/home/copiaseguridad/$usu"_$(date +%F) # se crea el directorio para la copia
    mkdir -p $dir
    cp -r /home/$usu $dir # y se crea la copia en el directorio
    echo "Copia de seguridad en: $dir"
  else
    echo "Usuario no valido, prueba con uno de la lista"
  fi
}

function alumnos {
  # declaramos los contadores de aprobados y suspensos
  aprobados=0
  suspensos=0
  # declaramos la suma de las notas como int
  declare -i sum_notas=0
  
  for (( i=1; i<=$1; i++ )); do
    read -p "Nombre del alumno $i: " alu # preguntamos nombre y nota
    read -p "Nota de $alu: " nota
    sum_notas=$(($sum_notas+$nota)) # añadimos la nota al total
    if [[ $nota -lt 5 ]]; then
      ((suspensos++)) # si la nota es menor que 5 se añade un suspenso
    else
      ((aprobados++)) # si no se añade un aprobado
    fi
  done
  echo "Numero de suspensos: $suspensos"
  echo "Numero de aprobados: $aprobados"
  media=$(($sum_notas/$1)) # la media es el total de notas entre el numero de alumnos
  echo "Nota media de la clase: $media"
  echo "Ten en cuenta que bash no trata numeros enteros, asi que se redondea el resultado"
}

function quita_blancos {
  # Obtener una lista de todos los ficheros en el directorio actual con espacios en el nombre
  files=$(find $PWD -name "* *" -type f)

  # Iterar sobre la lista de ficheros
  while IFS= read -r fichero; do
    nuevo=$(echo $fichero | tr ' ' '_') # Sustituir espacios por _
    mv -v "$fichero" "$nuevo" # Cambiar el nombre
  done <<< $files
  
  echo "Hecho!"
}

function lineas {
  # Asignar valores a las variables
  caracter=$1
  columnas=$2
  filas=$3

  # Verificar que columnas está entre 1 y 60
  if [ $columnas -lt 1 ] || [ $columnas -gt 60 ]; then
    echo "Error: el segundo parámetro debe estar entre 1 y 60"
    return
  fi

  # Verificar que filas está entre 1 y 10
  if [ $filas -lt 1 ] || [ $filas -gt 10 ]; then
    echo "Error: el tercer parámetro debe estar entre 1 y 10"
    return
  fi

  # Dibujar la "matriz"
  for ((i=1; i<=$filas; i++)); do
    for ((j=1; j<=$columnas; j++)); do
        echo -n $caracter # -n para evitar el salto de linea
    done
    echo ""
  done
}

echo "Bienvenido! Este es el examen de Luis. Se recomienda ejecutar como root." 
choice=0
while [ $choice != "exit" ]; do
  echo "Cuando quieras salir escribe 'exit'"
  read -p "Por favor indica el nombre del script que quieras ejecutar: " choice
  sleep 1
  echo "Has elegido el script $choice"
  case $choice in
  factorial)
    sleep 1
    read -p "Numero: " fact
    factorial $fact;;
  bisiesto)
    sleep 1
    read -p "Año: " year
    bisiesto $year;;
  configurarred)
    sleep 1
    read -p "IP: " ip
    read -p "Mascara: " mask
    read -p "Gateway: " gateway
    read -p "DNS: " dns
    configurarred $ip $mask $gateway $dns;;
  adivina)
    sleep 1
    adivina;;
  edad)
    sleep 1
    read -p "Edad: " edad1
    edad $edad1;;
  fichero)
    sleep 1
    read -p "Ruta absoluta del fichero: " ruta
    fichero $ruta;;
  buscar)
    sleep 1
    read -p "Nombre del archivo: " file
    buscar $file;;
  contar)
    sleep 1
    read -p "Ruta del directorio: " ruta
    contar $ruta;;
  privilegios)
    sleep 1
    privilegios;;
  romano)
    sleep 1
    read -p "Numero: " num
    romano $num;;
  automatizar)
    sleep 1
    automatizar;;
  crear)
    sleep 1
    read -p "Nombre del archivo: " name
    read -p "Tamaño del archivo: " size
    crea $name $size;;
  crear_2)
    sleep 1
    read -p "Nombre del archivo: " name
    read -p "Tamaño del archivo: " size
    crear_2 $name $size;;
  reescribir)
    sleep 1
    read -p "Palabra: " str
    reescribir $str;;
  contusu)
    sleep 1
    contusu;;
  alumnos)
    sleep 1
    read -p "Cuantos alumnos hay? " numalu
    alumnos $numalu;;
  quita_blancos)
    sleep 1
    quita_blancos;;
  lineas)
    sleep 1
    read -p "Caracter: " char
    read -p "Columnas: " col
    read -p "Filas: " filas
    lineas $char $col $filas;;
  exit)
    sleep 1
    echo "Hasta la proxima!";;
  *)
    sleep 1
    echo "Opcion no valida :("
  esac
done
