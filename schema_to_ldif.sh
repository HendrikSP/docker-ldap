#!/bin/sh

IN="$1"
OUT="$2"

[ ! -z "$IN" ] || IN=/in
[ ! -z "$OUT" ] || OUT=/out

find "$IN" -type f -name "*.schema" \
  | sort \
  | sed -e "s/^.*$/include &/" \
  > /tmp/slapd.conf

cat /tmp/slapd.conf

rm -fr "$OUT/*"

mkdir -p "$OUT/tmp"

slaptest -f /tmp/slapd.conf -F "$OUT/tmp"

find "$OUT/tmp/cn=config/cn=schema" -type f | while read f; do
  echo $f
  DEST=`echo $f | sed -e "s/^.*\/cn={[0-9]*}//"`
  echo $DEST

  cat "$f" \
    | sed -r -e  's/^dn: cn=\{0\}(.*)$/dn: cn=\1,cn=schema,cn=config/' \
  			-e 's/cn: \{0\}(.*)$/cn: \1/' \
  			-e '/^structuralObjectClass: /d' \
  			-e '/^entryUUID: /d' \
  			-e '/^creatorsName: /d' \
  			-e '/^createTimestamp: /d' \
  			-e '/^entryCSN: /d' \
  			-e '/^modifiersName: /d' \
  			-e '/^modifyTimestamp: /d' \
  			-e '/^# AUTO-GENERATED FILE - DO NOT EDIT!! Use ldapmodify./d' \
  			-e '/^# CRC32 [0-9a-f]+/d' \
  			-e 's/^cn: \{[0-9]*\}(.*)$/cn: \1/' \
  			-e 's/^dn: cn=\{[0-9]*\}(.*)$/dn: cn=\1,cn=schema,cn=config/' \
    > "$OUT/$DEST"
done

rm -fr "$OUT/tmp"
rm -f /tmp/slapd.conf
