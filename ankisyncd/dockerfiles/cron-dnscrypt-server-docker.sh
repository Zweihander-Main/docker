#! /usr/bin/env bash
set -eu

/usr/bin/dig . NS @75.127.96.89 > /opt/unbound/etc/unbound/var/opennic.cache
echo "0 0 1 * * /usr/bin/dig . NS @75.127.96.89 > /opt/unbound/etc/unbound/var/opennic.cache" \
	> /var/spool/cron/crontabs/_unbound
sed '5i\ \ root-hints: "/opt/unbound/etc/unbound/var/opennic.cache"' \
	/opt/unbound/etc/unbound/unbound.conf \
	> /opt/unbound/etc/unbound/unbound.conf

exec busybox crond -f -l 0 -L /dev/stdout
