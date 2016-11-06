# About

Docker Image to run `openldap`

``` sh
docker run --name ldap \
  -v $PWD/config:/etc/openldap/slapd.d:ro \
  -v $PWD/data:/var/lib/openldap/openldap-data \
  -v $PWD/backup:/backup \
  hendriksp/docker-ldap <addtional-agruments>
```

# Tools

## Initialize/Restore

``` sh
docker run --rm -ti \
  -v $PWD/config:/etc/openldap/slapd.d \
  -v $PWD/data:/var/lib/openldap/openldap-data \
  -v $PWD/init:/init:ro \
  hendriksp/docker-ldap \
  restore
```

Create config and database from a backup and/or ldif scripts. The `$PWD/init` folder should contain  subdirectories `cn` and `data` for config and data to import.
All files (also from any nested subdirectories) will be imported in lexicographical order.

## Backup

``` sh
docker exec ldap backup
```

## Convert Schemas to LDIFs

``` sh
docker run --rm -ti \
  -v $PWD/schema:/in:ro \
  -v $PWD/out:/out \
  hendriksp/docker-ldap \
  schema_to_ldif
```

Imports in lexicographical order all files ending with `.schema` in `$PWD/schema` and converts then to LDIF and stores them in `$PWD/out`.
