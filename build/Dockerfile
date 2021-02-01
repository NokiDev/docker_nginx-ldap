ARG alpine_version=3.10
FROM alpine:$alpine_version as nginx-build
ARG nginx_version=release-1.16.1

RUN echo "==> Installing dependencies..." \
 && apk update \
 && apk add --virtual build-deps \
    make gcc libc-dev openldap-dev \
    pcre-dev libressl-dev zlib-dev \
    linux-headers wget git

WORKDIR /build
RUN git clone https://github.com/kvspb/nginx-auth-ldap.git && git clone https://github.com/nginx/nginx.git

COPY ./build.sh /build/build.sh 

RUN chmod 700 /build/build.sh && /build/build.sh $nginx_version

FROM alpine:$alpine_version as nginx-run

ARG dockerize_version=v0.6.1

COPY --from=nginx-build "/usr/local/nginx/" "/usr/local/nginx/"
COPY --from=nginx-build "/etc/nginx/" "/etc/nginx/"

RUN echo "==> Configuring system" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& mkdir /etc/nginx/conf.d \
	&& rm -f /etc/nginx/*.default \
	&& mkdir /var/log/nginx \
        && touch /var/log/nginx/access.log /var/log/nginx/error.log \
	&& mkdir -p /usr/share/nginx/html \
	&& install -m644 /usr/local/nginx/html/index.html /usr/share/nginx/html/ \
	&& install -m644 /usr/local/nginx/html/50x.html /usr/share/nginx/html/ \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/sbin/nginx \
	&& apk update \
	&& apk add --no-cache \
        libpcrecpp libpcre16 libpcre32 libressl libssl1.1 pcre libldap libgcc libstdc++ \
	&& rm -rf /var/cache/apk/* \
	&& wget -O /tmp/dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/$dockerize_version/dockerize-alpine-linux-amd64-$dockerize_version.tar.gz \
	&& tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
	&& rm -rf /tmp/dockerize.tar.gz

COPY nginx.default.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.config

WORKDIR /usr/local/nginx

EXPOSE 80 443

COPY run.sh /run.sh
CMD ["/run.sh"]