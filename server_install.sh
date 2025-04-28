#!/bin/bash

# MC Server Install Script V1.0, Author @RafaxWolf

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
sudo yum update -y

# Instalar dependencias
echo -e "${blueColour}[+] Instalando dependencias...${endColour}\n"
sudo yum install java-17-amazon-corretto -y  # Asegúrate de que es compatible con Minecraft

wait 1000

# Abrir el puerto 25565 (TCP y UDP)
echo -e "${yellowColour}[+] Abriendo puerto: 25565${endColour}"

sudo iptables -I INPUT -p tcp --dport 25565 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 25565 -j ACCEPT
sudo service iptables save

echo -e "${greenColour}[+] Puerto abierto.${endColour}\n"

wait 1000

# Crear la carpeta del servidor y moverse a ella
echo -e "${greenColour}[+] Creando la carpeta del servidor...${endColour}"

mkdir -p /home/ec2-user/minecraft-server
cd /home/ec2-user/minecraft-server

echo -e "${greenColour}[+] Carpeta creada.${endColour}"

# Descargar el servidor de Minecraft
echo -e "${greenColour}[+] Descargando server.jar...${endColour}"

wget -O server.jar https://launcher.mojang.com/v1/objects/$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release')

echo -e "${greenColour}[+] server.jar Descargado.${endColour}"

# Aceptar el EULA
echo "eula=true" > eula.txt
echo -e "${turquoiseColour}[+] Eula aceptado.${endColour}"

# Configurar `server.properties`
echo -e "${blueColour}[+] Configurando el servidor...${endColour}\n"

echo "motd=Servidor de Minecraft en Amazon Linux" >> server.properties
echo "online-mode=false" >> server.properties  # Permite modo No Premium

echo -e "${greenColour}[+] Servidor configurado.${endColour}\n"

# Crear el script de inicio
echo -e "${greenColour}[+] Creando el ejecutable del servidor...${endColour}"

echo "#!/bin/bash
cd /home/ec2-user/minecraft-server
java -Xmx2G -Xms2G -jar server.jar nogui" > /home/ec2-user/minecraft-server/start_server.sh
chmod +x /home/ec2-user/minecraft-server/start_server.sh

echo -e "${greenColour}[+] Ejecutable Creado.${endColour}\n"

wait 1000

# Crear el servicio `minecraft.service`
echo -e "${greenColour}[+] Creando servicio del servidor...${endColour}"

sudo bash -c 'cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/minecraft-server
ExecStart=/home/ec2-user/minecraft-server/start_server.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

echo -e "${greenColour}[+] Servicio creado.${endColour}\n"

# Habilitar y arrancar el servicio
sudo systemctl enable minecraft
sudo systemctl start minecraft

echo -e "${greenColour}[+] Servicio Habilitado.${endColour}\n"

wait 2000

echo -e "\n${greenColour}[+] Instalación completada y Servidor en ejecución.${endColour}"
exit 0