ARG ALPINE_S6_TAG=3.15-2.2.0.3

ARG LIBSIG_VERSION=3.0.3
ARG CARES_VERSION=1.17.2
ARG CURL_VERSION=7.78.0
ARG XMLRPC_VERSION=01.58.00
ARG LIBTORRENT_VERSION=v0.13.8
ARG RTORRENT_VERSION=v0.9.8
ARG MKTORRENT_VERSION=v1.1

ARG NGINX_VERSION=1.21.1
ARG NGINX_DAV_VERSION=v3.0.0
ARG NGINX_UID=102
ARG NGINX_GID=102
ARG GEOIP2_PHPEXT_VERSION=1.1.1

# 3.10
ARG RUTORRENT_VERSION=954479ffd00eb58ad14f9a667b3b9b1e108e80a2
ARG GEOIP2_RUTORRENT_VERSION=9f7b59e29bc472eec8c3943d7646bf9462577b16

FROM alpine AS src
RUN apk --update --no-cache add curl git subversion tar tree xz
WORKDIR /src

FROM src AS src-mktorrent
ARG MKTORRENT_VERSION
RUN git clone https://github.com/esmil/mktorrent.git . && \
    git reset --hard $MKTORRENT_VERSION

FROM src AS src-nginx
ARG NGINX_VERSION
ARG NGINX_DAV_VERSION
RUN curl -sSL "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" | tar xz --strip 1
RUN git clone https://github.com/arut/nginx-dav-ext-module.git nginx-dav-ext && \
    cd nginx-dav-ext && \
    git reset --hard $NGINX_DAV_VERSION

FROM src AS src-geoip2-phpext
ARG GEOIP2_PHPEXT_VERSION
RUN curl -SsL "https://pecl.php.net/get/geoip-${GEOIP2_PHPEXT_VERSION}.tgz" -o "geoip.tgz"

FROM src AS src-rutorrent
ARG RUTORRENT_VERSION
RUN git clone https://github.com/Novik/ruTorrent.git . && \
    git reset --hard $RUTORRENT_VERSION && \
    rm -rf .git* conf/users plugins/geoip share

FROM src AS src-geoip2-rutorrent
ARG GEOIP2_RUTORRENT_VERSION
RUN git clone https://github.com/Micdu70/geoip2-rutorrent . && \
    git reset --hard $GEOIP2_RUTORRENT_VERSION && \
    rm -rf .git*

FROM src AS src-mmdb
RUN curl -SsOL "https://github.com/crazy-max/geoip-updater/raw/mmdb/GeoLite2-City.mmdb" \
    && curl -SsOL "https://github.com/crazy-max/geoip-updater/raw/mmdb/GeoLite2-Country.mmdb"

FROM crazymax/alpine-s6:${ALPINE_S6_TAG} AS builder
RUN apk --update --no-cache add \
    autoconf \
    automake \
    binutils \
    brotli-dev \
    build-base \
    cppunit-dev \
    gd-dev \
    geoip-dev \
    libtool \
    libxslt-dev \
    linux-headers \
    ncurses-dev \
    nghttp2-dev \
    openssl-dev \
    pcre-dev \
    php7-dev \
    php7-pear \
    tar \
    tree \
    xz \
    zlib-dev

ENV DIST_PATH="/dist"

WORKDIR /usr/local/src/mktorrent
COPY --from=src-mktorrent /src .
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/nginx
COPY --from=src-nginx /src .
ARG NGINX_UID
ARG NGINX_GID
RUN addgroup -g ${NGINX_UID} -S nginx
RUN adduser -S -D -H -u ${NGINX_GID} -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN ./configure \
    --prefix=/usr/lib/nginx \
    --sbin-path=/sbin/nginx \
    --pid-path=/var/pid/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/dev/stdout \
    --error-log-path=/dev/stderr \
    --pid-path=/var/pid/nginx.pid \
    --user=nginx \
    --group=nginx \
    --with-file-aio \
    --with-pcre-jit \
    --with-threads \
    --with-poll_module \
    --with-select_module \
    --with-stream_ssl_module \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_degradation_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-mail_ssl_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail=dynamic \
    --with-stream=dynamic \
    --with-http_geoip_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_xslt_module=dynamic \
    --add-dynamic-module=./nginx-dav-ext
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/geoip2-phpext
COPY --from=src-geoip2-phpext /src .
RUN pecl install geoip.tgz
RUN mkdir -p ${DIST_PATH}/usr/lib/php7/modules
RUN cp -f /usr/lib/php7/modules/geoip.so ${DIST_PATH}/usr/lib/php7/modules/
RUN tree ${DIST_PATH}

FROM crazymax/alpine-s6:${ALPINE_S6_TAG}
COPY --from=builder /dist /
COPY --from=src-rutorrent --chown=nobody:nogroup /src /var/www/rutorrent
COPY --from=src-geoip2-rutorrent --chown=nobody:nogroup /src /var/www/rutorrent/plugins/geoip2
COPY --from=src-mmdb /src /var/mmdb

ENV PYTHONPATH="$PYTHONPATH:/var/www/rutorrent" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
    TZ="UTC" \
    PUID="1000" \
    PGID="1000"

# unrar package is not available since alpine 3.15
RUN echo "@314 http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories \
    && apk --update --no-cache add unrar@314

ARG NGINX_UID
ARG NGINX_GID
RUN apk --update --no-cache add \
    apache2-utils \
    bash \
    bind-tools \
    binutils \
    brotli \
    ca-certificates \
    coreutils \
    dhclient \
    ffmpeg \
    findutils \
    geoip \
    grep \
    gzip \
    libstdc++ \
    mediainfo \
    ncurses \
    openssl \
    pcre \
    php7 \
    php7-bcmath \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-fpm \
    php7-json \
    php7-mbstring \
    php7-openssl \
    php7-phar \
    php7-posix \
    php7-session \
    php7-sockets \
    php7-xml \
    php7-zip \
    php7-zlib \
    python3 \
    py3-pip \
    shadow \
    sox \
    tar \
    tzdata \
    unzip \
    util-linux \
    zip \
    zlib \
    && ln -s /usr/lib/nginx/modules /etc/nginx/modules \
    && addgroup -g ${NGINX_UID} -S nginx \
    && adduser -S -D -H -u ${NGINX_GID} -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && pip3 install --upgrade pip \
    && pip3 install cfscrape cloudscraper \
    && addgroup -g ${PGID} rtorrent \
    && adduser -D -H -u ${PUID} -G rtorrent -s /bin/sh rtorrent \
    && rm -rf /tmp/*

COPY rootfs /

VOLUME [ "/data", "/passwd", "/socket", "/downloads" ]
ENTRYPOINT [ "/init" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
    CMD /usr/local/bin/healthcheck
