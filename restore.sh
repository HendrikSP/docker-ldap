#!/bin/sh
set -e

INIT=/init
CN_DIR=/etc/openldap/slapd.d
DATA_DIR=/var/lib/openldap/openldap-data

if [ ! `ls -A "$CN_DIR"` ]; then
  echo "Importing CN to '$CN_DIR'"

  mkdir -p "$CN_DIR"

  find "$INIT/cn" -type f | sort | while read f; do
    echo "Importing $f ..."
    slapadd -F "$CN_DIR" -n 0 -l "$f"
  done
  chown -R ldap.ldap "$CN_DIR"
  chmod 700 "$CN_DIR"
else
  echo "Directory '$CN_DIR' exists, skipping CN import"
fi

if [ ! `ls -A "$DATA_DIR"` ]; then
  echo "Importing data"
  if [ -d "$INIT/data" ]; then
    find "$INIT/data" -type f | sort | while read f; do
      echo "Importing $f ..."
      slapadd -l "$f"
    done
  else
    echo "'$INIT/data' does not exist. Skipping import."
  fi
  chown -R ldap.ldap "$DATA_DIR"
  chmod 700 "$DATA_DIR"
else
  echo "Directory '$DATA_DIR' exists, skipping data import"
fi
