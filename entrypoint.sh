#!/bin/sh
set -e

# first arg is `-...`
if [ "${1#-}" != "$1" ]; then
  # always set the user, and -d (0=no debug) to prevent backgrounding
	set -- /usr/sbin/slapd -u ldap -g ldap -d 0 "$@"
fi

exec "$@"
