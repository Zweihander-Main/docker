#! /usr/bin/env bash
set -eu

/usr/bin/dig . NS @75.127.96.89 > /opt/unbound/etc/unbound/var/opennic.cache
echo "0 0 1 * * /usr/bin/dig . NS @75.127.96.89 > /opt/unbound/etc/unbound/var/opennic.cache" \
	> /var/spool/cron/crontabs/_unbound

exec busybox crond -f -l 8 -L /dev/stdout
