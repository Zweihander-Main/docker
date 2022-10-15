#!/usr/bin/with-contenv sh

echo "Fixing perms..."
mkdir -p /data/rtorrent \
  /config \
  /session \
  /socket \
  /watch/load \
  /watch/start \
  /downloads/complete \
  /downloads/temp \
  /etc/rtorrent \
  /var/run/rtorrent
chown rtorrent. \
  /config \
  /session \
  /socket \
  /var/log/rtorrent-error.log \
  /var/log/rtorrent-info.log
chown -R rtorrent. \
  /downloads \
  /watch \
  /etc/rtorrent \
  /tpls \
  /var/run/rtorrent
