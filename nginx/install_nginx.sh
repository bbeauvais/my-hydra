#!/bin/bash
#
# Installation en tant que service d'un version compilé de nginx depuis un fichier tar.gz 
#

echo "Chemin vers l'archive contenant nginx : "
read archive_path

if [[ $archive_path = "" ]]
then
    echo "Chemin vers l'archive invalide"
    exit 1
fi

default_install_path="/usr/local/nginx"
echo "Choisir le repertoire d'installation (laisser vide pour defaut $default_install_path) : "
read install_path

if [[ $install_path = "" ]]
then
    install_path=$default_install_path
fi

tar xf $archive_path -C $install_path || exit 1

cat <<EOF >/lib/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=$install_path/nginx.pid
ExecStartPre=$install_path/nginx -t
ExecStart=$install_path/nginx
ExecReload=$install_path/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nginx.service
systemctl start nginx.service