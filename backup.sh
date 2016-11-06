#!/bin/sh
set -e
slapcat -n 0 -l /backup/0-config.ldif
slapcat -n 1 -l /backup/1-data.ldif
