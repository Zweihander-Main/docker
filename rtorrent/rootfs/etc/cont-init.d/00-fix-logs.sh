#!/usr/bin/with-contenv sh

echo "${PUID}"
echo "${PGID}"
echo "$(env)"
# Fix access rights to stdout and stderr
chown ${PUID}:${PGID} /proc/self/fd/1 /proc/self/fd/2 || true

ln -sf /dev/stdout /var/log/rtorrent-info.log && \
ln -sf /dev/stderr /var/log/rtorrent-error.log
