#!/usr/bin/with-contenv sh

mkdir -p /etc/services.d/rtorrent
cat > /etc/services.d/rtorrent/run <<EOL
#!/usr/bin/execlineb -P
with-contenv
/bin/export HOME /session
/bin/export PWD /session
s6-setuidgid ${PUID}:${PGID}
EOL
if [ -z "${WAN_IP}" ]; then
  echo "rtorrent -D -o import=/etc/rtorrent/.rtlocal.rc" >> /etc/services.d/rtorrent/run
else
  echo "rtorrent -D -o import=/etc/rtorrent/.rtlocal.rc -i ${WAN_IP}" >> /etc/services.d/rtorrent/run
fi

chmod +x /etc/services.d/rtorrent/run
