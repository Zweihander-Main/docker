#!/usr/bin/with-contenv sh

#WAN_IP=${WAN_IP:-10.0.0.1}
#WAN_IP_CMD=${WAN_IP_CMD:-"dig +short myip.opendns.com @resolver1.opendns.com"}

TZ=${TZ:-UTC}
AUTH_DELAY=${AUTH_DELAY:-0s}
REAL_IP_FROM=${REAL_IP_FROM:-0.0.0.0/32}
REAL_IP_HEADER=${REAL_IP_HEADER:-X-Forwarded-For}
XMLRPC_SIZE_LIMIT=${XMLRPC_SIZE_LIMIT:-1M}
XMLRPC_AUTHBASIC_STRING=${XMLRPC_AUTHBASIC_STRING:-rTorrent XMLRPC restricted access}
XMLRPC_PORT=${XMLRPC_PORT:-8000}
XMLRPC_HEALTH_PORT=$((XMLRPC_PORT + 1))

RT_LOG_LEVEL=${RT_LOG_LEVEL:-info}
RT_LOG_EXECUTE=${RT_LOG_EXECUTE:-false}
RT_LOG_XMLRPC=${RT_LOG_XMLRPC:-false}
RT_DHT_PORT=${RT_DHT_PORT:-6881}
RT_INC_PORT=${RT_INC_PORT:-50000}

# WAN IP
if [ -z "$WAN_IP" ] && [ -n "$WAN_IP_CMD" ]; then
  WAN_IP=$(eval "$WAN_IP_CMD")
fi
if [ -n "$WAN_IP" ]; then
  echo "Public IP address enforced to ${WAN_IP}"
fi
printf "%s" "$WAN_IP" > /var/run/s6/container_environment/WAN_IP

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Healthcheck
echo "Update healthcheck script..."
cat > /usr/local/bin/healthcheck <<EOL
#!/bin/sh
set -e

# rTorrent
curl --fail -d "<?xml version='1.0'?><methodCall><methodName>system.api_version</methodName></methodCall>" http://127.0.0.1:${XMLRPC_HEALTH_PORT}

EOL

# Init
echo "Initializing files and folders..."
mkdir -p /downloads/complete \
         /downloads/temp

# Remove session lock from previous instances
rm -f /session/rtorrent.lock

# rTorrent local config
echo "Checking rTorrent local configuration..."
sed -e "s!@RT_LOG_LEVEL@!$RT_LOG_LEVEL!g" \
  -e "s!@RT_DHT_PORT@!$RT_DHT_PORT!g" \
  -e "s!@RT_INC_PORT@!$RT_INC_PORT!g" \
  -e "s!@XMLRPC_SIZE_LIMIT@!$XMLRPC_SIZE_LIMIT!g" \
  /tpls/etc/rtorrent/.rtlocal.rc > /etc/rtorrent/.rtlocal.rc
if [ "${RT_LOG_EXECUTE}" = "true" ]; then
  echo "  Enabling rTorrent execute log..."
  sed -i "s!#log\.execute.*!log\.execute = (cat,(cfg.logs),\"execute.log\")!g" /etc/rtorrent/.rtlocal.rc
fi
if [ "${RT_LOG_XMLRPC}" = "true" ]; then
  echo "  Enabling rTorrent xmlrpc log..."
  sed -i "s!#log\.xmlrpc.*!log\.xmlrpc = (cat,(cfg.logs),\"xmlrpc.log\")!g" /etc/rtorrent/.rtlocal.rc
fi

# rTorrent config
echo "Checking rTorrent configuration..."
if [ ! -f /config/.rtorrent.rc ]; then
  echo "  Creating default configuration..."
  cp /tpls/.rtorrent.rc /config/.rtorrent.rc
fi
chown rtorrent. /config/.rtorrent.rc

echo "Fixing perms..."
chown rtorrent. \
  /downloads \
  /downloads/complete \
  /downloads/temp
chown -R rtorrent. \
  /session \
  /watch \
  /etc/rtorrent
chmod 644 \
  /config/.rtorrent.rc \
  /etc/rtorrent/.rtlocal.rc
