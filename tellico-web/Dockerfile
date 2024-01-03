ARG TELLICO_VERSION=3.5.3

FROM alpine:latest AS src
RUN apk --update --no-cache add curl git tar tree xz
WORKDIR /src

FROM src as src-tellico
ARG TELLICO_VERSION
RUN curl -SsL "https://tellico-project.org/files/tellico-${TELLICO_VERSION}.tar.xz" | tar xJ --strip 1

FROM alpine:3.18 AS builder
RUN apk --update --no-cache add \
    autoconf \
    automake \
    binutils \
    build-base \
    tar \
    tree \
    xz \
    cmake \
    extra-cmake-modules \
    kdelibs4support-dev \
    qt5-qtwebengine-dev \
    qt5-qtcharts-dev \
    taglib-dev \
    poppler-dev \
    poppler-qt5-dev \
    exempi-dev \
    knewstuff-dev \
    kfilemetadata-dev \
    libcdio-dev \
    libkcddb-dev \
    libksane-dev \
    perl-text-bibtex

ENV DIST_PATH="/dist"
WORKDIR /usr/local/src/tellico
COPY --from=src-tellico /src .
RUN cmake . -DCMAKE_INSTALL_PREFIX=`kf5-config --prefix`
RUN make -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)
RUN tree ${DIST_PATH}

FROM jlesage/baseimage-gui:alpine-3.17-v4
ARG TELLICO_VERSION

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV KEEP_APP_RUNNING 1
ENV DARK_MODE 0
ENV WEB_LISTENING_PORT 8080
ENV ENABLE_CJK_FONT 1
ENV DISPLAY_WIDTH 1920
ENV DISPLAY_HEIGHT 1080

COPY --from=builder /dist /
COPY /rootfs /
RUN add-pkg ca-certificates kded dbus-x11 mesa-dri-gallium \
    qt5-qtwebengine qt5-qtcharts taglib poppler poppler-qt5 exempi \
    knewstuff kfilemetadata libcdio libkcddb libksane perl-text-bibtex \
    kdelibs4support kitemmodels kio breeze-icons plasma-integration && \
    mkdir -p /usr/share/desktop-directories /data /data/.config /data/.local/share/tellico && \
    cp /usr/share/tellico/tellico-common.xsl /data/.local/share/tellico/tellico-common.xsl && \
    set-cont-env APP_NAME "Tellico" && \
    set-cont-env APP_VERSION "${TELLICO_VERSION}" && \
    set-cont-env HOME "/data" && \
    set-cont-env XDG_CONFIG_HOME "/data/.config" && \
    set-cont-env XDG_DATA_HOME "/data/.local/share" && \
    take-ownership /data && \
    APP_ICON_URL=https://tellico-project.org/wp-content/uploads/2019/07/cropped-tellico-512-270x270.png && \
    install_app_icon.sh "$APP_ICON_URL"

VOLUME /data
WORKDIR /data
EXPOSE 8080
