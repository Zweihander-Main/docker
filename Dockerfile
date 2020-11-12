FROM golang:1.14-buster AS easy-novnc-build
MAINTAINER Zweihänder

WORKDIR /src

RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:testing-20201012-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends tigervnc-standalone-server \
	supervisor gosu ca-certificates ratpoison plasma-desktop dbus-x11 \
	kio-extras tellico  && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY supervisord.conf /etc/
EXPOSE 8080

RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    mkdir -p /data
VOLUME /data
WORKDIR /data

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec gosu app supervisord"]