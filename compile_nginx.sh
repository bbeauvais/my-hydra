#!/bin/bash
#
# Téléchargement des dépendances, configuration et compilation avec modules de NGINX à partir des sources
#

apt install g++ make

mkdir nginx_install_tmp
cd nginx_install_tmp

# Dépendance PCRE
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.42.tar.gz
tar -zxf pcre-8.42.tar.gz
cd pcre-8.42
./configure
make
make install

cd ..

# Dépendance ZLIB
wget http://zlib.net/zlib-1.2.11.tar.gz
tar -zxf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make
make install

cd ..

# Dépendance OpenSSL
wget http://www.openssl.org/source/openssl-1.0.2o.tar.gz
tar -zxf openssl-1.0.2o.tar.gz
cd openssl-1.0.2o
./Configure linux-x86_64 --prefix=/usr
make
make install

cd ..

# NGINX
wget https://nginx.org/download/nginx-1.14.0.tar.gz
tar zxf nginx-1.14.0.tar.gz
cd nginx-1.14.0
./configure --sbin-path=/usr/local/nginx/nginx \
    --conf-path=/usr/local/nginx/nginx.conf \
    --pid-path=/usr/local/nginx/nginx.pid \
    --with-pcre=../pcre-8.42 \
    --with-zlib=../zlib-1.2.11 \
    --with-http_ssl_module \
    --with-http_auth_request_module

make
make install
