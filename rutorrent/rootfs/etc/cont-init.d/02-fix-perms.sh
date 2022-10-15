#!/usr/bin/with-contenv sh

echo "Fixing perms..."
mkdir -p /data/rutorrent \
  /downloads \
  /passwd \
  /etc/nginx/conf.d \
  /var/cache/nginx \
  /var/lib/nginx \
  /var/run/nginx \
  /var/run/php-fpm
chown rtorrent. \
  /data \
  /data/rutorrent \
  /downloads
chown -R rtorrent. \
  /passwd \
  /tpls \
  /var/cache/nginx \
  /var/lib/nginx \
  /var/log/php7 \
  /var/run/nginx \
  /var/run/php-fpm
