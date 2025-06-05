#!/bin/bash

###    MC Server Installer Script V1.0, Author @RafaxWolf          

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Salir con Ctrl_C
trap ctrl_c INT

function ctrl_c(){
    echo -e "${redColour}\n[!] Saliendo...\n${endColour}"
    exit 1
}

# Verificar si el usuario es root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${redColour}[!] Este script debe ejecutarse como root.${endColour}"
    exit 1
fi

# Verifica cual sistema operativo es

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
else
    echo -e "${redColour}[!] No se pudo determinar el sistema operativo.${endColour}"
    exit 1
fi

if [[ "$OS" == "Amazon Linux" || "$OS" == "Amazon Linux 2" ]]; then
    ./AWS/Amazon\ Linux/server_install.sh
    
else if [[ "$OS" == "Arch Linux" ]]; then
    ./Ubuntu/server_install.sh
    
else
    echo -e "${redColour}[!] Sistema operativo no soportado. Por favor, usa Amazon Linux o Ubuntu/Debian.${endColour}"
    exit 1
fi