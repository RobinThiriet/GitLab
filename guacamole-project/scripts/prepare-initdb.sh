#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
INITDB_DIR="${ROOT_DIR}/initdb"
INITDB_SQL="${INITDB_DIR}/001-guacamole-initdb.sql"
IMAGE_TAG="${GUACAMOLE_IMAGE_TAG:-1.6.0}"

mkdir -p "${INITDB_DIR}"

docker run --rm "guacamole/guacamole:${IMAGE_TAG}" \
  /opt/guacamole/bin/initdb.sh --postgresql > "${INITDB_SQL}"

test -s "${INITDB_SQL}"
echo "Schema Guacamole genere dans ${INITDB_SQL}"
