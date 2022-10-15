ARG ALPINE_S6_TAG=3.15-2.2.0.3
ARG LIBSIG_VERSION=3.0.3
ARG CARES_VERSION=1.17.2
ARG CURL_VERSION=7.78.0
ARG XMLRPC_VERSION=01.58.00
ARG LIBTORRENT_VERSION=v0.13.8
ARG RTORRENT_VERSION=v0.9.8

FROM alpine AS src
RUN apk --update --no-cache add curl git subversion tar tree xz
WORKDIR /src

FROM src AS src-libsig
ARG LIBSIG_VERSION
RUN curl -sSL "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/3.0/libsigc++-${LIBSIG_VERSION}.tar.xz" | tar xJv --strip 1

FROM src AS src-cares
ARG CARES_VERSION
RUN curl -sSL "https://c-ares.haxx.se/download/c-ares-${CARES_VERSION}.tar.gz" | tar xz --strip 1

FROM src AS src-xmlrpc
ARG XMLRPC_VERSION
RUN svn checkout "http://svn.code.sf.net/p/xmlrpc-c/code/release_number/${XMLRPC_VERSION}/" .

FROM src AS src-curl
ARG CURL_VERSION
RUN curl -sSL "https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz" | tar xz --strip 1

FROM src AS src-libtorrent
ARG LIBTORRENT_VERSION
RUN git clone https://github.com/rakshasa/libtorrent.git . && \
    git reset --hard $LIBTORRENT_VERSION

FROM src AS src-rtorrent
ARG RTORRENT_VERSION
RUN git clone https://github.com/rakshasa/rtorrent.git . && \
    git reset --hard $RTORRENT_VERSION

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

WORKDIR /usr/local/src/libsig
COPY --from=src-libsig /src .
RUN ./configure
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/cares
COPY --from=src-cares /src .
RUN ./configure
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/curl
COPY --from=src-curl /src .
RUN ./configure \
    --enable-ares \
    --enable-tls-srp \
    --enable-gnu-tls \
    --with-brotli \
    --with-ssl \
    --with-zlib
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/xmlrpc
COPY --from=src-xmlrpc /src .
RUN ./configure --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/libtorrent
COPY --from=src-libtorrent /src .
RUN ./autogen.sh
RUN ./configure \
    --with-posix-fallocate
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

WORKDIR /usr/local/src/rtorrent
COPY --from=src-rtorrent /src .
RUN ./autogen.sh
RUN ./configure \
    --with-xmlrpc-c \
    --with-ncurses
RUN make -j$(nproc)
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

FROM crazymax/alpine-s6:${ALPINE_S6_TAG}
COPY --from=builder /dist /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
    TZ="UTC" \
    PUID=1000 \
    PGID=1000

RUN apk --update --no-cache add \
    bash \
    ca-certificates \
    nghttp2-libs \
    brotli-libs \
    binutils \
    tzdata \
    && addgroup -g ${PGID} rtorrent \
    && adduser -D -H -u ${PUID} -G rtorrent -s /bin/sh rtorrent \
    && curl --version \
    && rm -rf /tmp/*

COPY rootfs /

VOLUME ["/config", "/session", "/socket", "/watch", "/downloads"]

ENTRYPOINT [ "/init" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
    CMD /usr/local/bin/healthcheck
