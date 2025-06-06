#!/bin/bash

###    MC Server Installer Script V1.5, Author @RafaxWolf          

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

echo -e "${greenColour} Bienvenido al Script para la Instalación de Servidores de Minecraft ${endColour}"
echo -e \t${blueColour} Version: 1.5 ${endColour}"
echo -e "\t${blueColour} Creado por RafaxWolf ${endColour}"

# Verificar si el usuario es root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${redColour}[!] Este script debe ejecutarse como root. [!]${endColour}"
    echo -e "${redColour}\n[!] Saliendo...\n${endColour}"
    wait 1000
    clear
    exit 13
fi

# Verifica cual es la distribución de Linux
if [ -f /etc/os-release ]; then
echo -e "${blueColour}[+] Detectando cual es su Distribución...${endColour}"
    . /etc/os-release
    OS=$NAME
else
    echo -e "${redColour}[!] No se pudo determinar su Distribución!${endColour}"
    echo -e "${redColour}[!] Por favor, asegurese de que su sistema tenga el archivo /etc/os-release.${endColour}"
    wait 1000
    echo -e "${redColour}[!] Saliendo...${endColour}"
    wait 500
    clear
    exit 2
fi

if [[ "$OS" == "Amazon Linux" || "$OS" == "Amazon Linux 2" ]]; then
    ./AWS/Amazon\ Linux/server_install.sh
    exit
else 
    if [[ "$OS" == "Arch Linux" ]]; then
    ./Linux/Arch\ Linux/server_install.sh
    exit
else 
    if [[ "$OS" == "Ubuntu" || "$OS" == "Debian GNU/Linux" ]]; then
    ./Linux/Ubuntu/server_install.sh
    exit
else
    if [[ "$OS" == "Debian GNU/Linux" || "$OS" == "Red Hat Enterprise Linux Server" ]]; then
    ./Linux/Debian/server_install.sh
    exit
else
    if [[ "$OS" == "Fedora" ]]; then
    ./Linux/Fedora/server_install.sh
    exit
else
    if [[ "$OS" == "Linux Mint" ]]; then
    ./Linux/Linux\ Mint/server_install.sh
    exit
else
    if [[ "$OS" == "Parrot OS" || "$OS" == "Kali GNU/Linux" ]]; then
    echo -e "${yellowColour}[!] Parrot OS y Kali GNU/Linux son distros enfocadas a la Ciberseguridad.\n Si aun desea crear su servidor en su sistema utilize: ./installer.sh -F  (El -F forzara al script a continuar incluso si su distribución esta enfocada a Ciberseguridad)${endColour}"
    exit 1
else
    echo -e "${redColour}[!] Distribución de Linux no soportada. Por favor, revise el README para encontrar las Distros Compatibles con el Script!${endColour}"
    exit 1
fi