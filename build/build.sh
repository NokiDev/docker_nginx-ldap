#!/bin/sh

NGINX_VERSION=$1

mkdir -p /var/log/nginx && mkdir -p /etc/nginx
cd nginx
echo "Building $NGINX_VERSION"
git checkout tags/${NGINX_VERSION}
	
./auto/configure \
--add-module=/build/nginx-auth-ldap \
--with-http_ssl_module \
--with-debug \
--conf-path=/etc/nginx/nginx.conf \
#--sbin-path=/usr/sbin/nginx \ 
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-stream \
--with-stream_ssl_module \
--with-debug \
--with-file-aio \
--with-threads \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_v2_module \
--with-http_auth_request_module \

echo "==> Building Nginx..." 
make -j$(getconf _NPROCESSORS_ONLN) 
make install
