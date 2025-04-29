#!/bin/bash

# # MC Server Install Script V1.0, Author @RafaxWolf, For Arch Linux

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

# Actualizar el sistema
echo -e "${yellowColour}[+] Actualizando el sistema...${endColour}\n$"
sudo pacman -Syu --noconfirm

# Instalar dependencias
echo -e "${blueColour}[+] Instalando dependencias...${endColour}\n"
sudo pacman -S --noconfirm jre-openjdk wget iptables jq
echo -e "${greenColour}[+] Dependencias instaladas.${endColour}\n"

wait 1000

# Abrir el puerto 25565 (TCP y UDP)
echo -e "${yellowColour}[+] Abriendo puerto: 25565${endColour}"
sudo iptables -I INPUT -p tcp --dport 25565 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 25565 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/iptables.rules
sudo systemctl enable iptables
sudo systemctl start iptables
echo -e "${greenColour}[+] Puerto abierto.${endColour}\n"

wait 1000

# Crear la carpeta del servidor y moverse a ella
echo -e "${greenColour}[+] Creando la carpeta del servidor...${endColour}"
mkdir -p /home/$(whoami)/minecraft-server
cd /home/$(whoami)/minecraft-server
echo -e "${greenColour}[+] Carpeta creada.${endColour}"

# Crear un menú con 3 opciones
echo -e "${purpleColour}\n[+] Seleccione tipo de servidor a instalar:${endColour}"
echo -e "1) Vanilla"
echo -e "2) Spigot"
echo -e "3) PaperMC"
read -p "Ingrese el número de la opción: " option

case $option in
    1)
        echo -e "\n[+] Has seleccionado un servidor tipo Vanilla"
        read -p "Ingrese la versión de Minecraft que desea instalar (por ejemplo, 1.20.1 / 1.12.2 / latest para seleccionar la ultima): " version
        echo -e "${greenColour}[+] Versión seleccionada: $version${endColour}"
        ;;
    2)
        echo -e "\n[+] Has seleccionado un servidor tipo Vanilla"
        read -p "Ingrese la versión de Minecraft que desea instalar (por ejemplo, 1.20.1 / 1.12.2 / latest para seleccionar la ultima): " version
        echo -e "${greenColour}[+] Versión seleccionada: $version${endColour}"
        ;;
    3)
        echo -e "\nOpción 3"
        ;;
    *)
        echo -e "${redColour}\n[!] Opción no válida.${endColour}"
        ;;
esac

# Descargar el servidor de Minecraft
echo -e "${greenColour}[+] Descargando server.jar...${endColour}"

wget -O server.jar https://launcher.mojang.com/v1/objects/$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release')

echo -e "${greenColour}[+] server.jar Descargado.${endColour}"

java -Xmx2G -jar server.jar nogui

# Aceptar el EULA
echo "eula=true" > eula.txt
echo -e "${turquoiseColour}[+] Eula aceptado.${endColour}"

# Configurar `server.properties`