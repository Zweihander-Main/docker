ARG TELLICO_VERSION=3.4.4-1

FROM golang:1-bullseye AS easy-novnc-build

WORKDIR /src

RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:bookworm-slim

ARG TELLICO_VERSION

ENV UID=1000
ENV GID=1000

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends tigervnc-standalone-server \
    supervisor gosu ca-certificates ratpoison plasma-desktop dbus-x11 \
    kio-extras tellico=$TELLICO_VERSION && \
    apt-get clean && rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories && \
    groupadd --gid $GID app && \
    useradd --home-dir /data --shell /bin/bash --uid $UID --gid $GID app && \
    mkdir -p /data

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY ./bin/supervisord.conf /etc/
EXPOSE 8080

VOLUME /data
WORKDIR /data

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec gosu app supervisord"]
