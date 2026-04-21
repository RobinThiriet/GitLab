#!/bin/sh

set -eu

PORT="${1:-8081}"
ATTEMPTS="${ATTEMPTS:-60}"
SLEEP_SECONDS="${SLEEP_SECONDS:-2}"
i=1

while [ "${i}" -le "${ATTEMPTS}" ]; do
  if docker run --rm --network host curlimages/curl:8.8.0 -fsS "http://localhost:${PORT}/" >/dev/null; then
    echo "Guacamole repond sur http://localhost:${PORT}/"
    exit 0
  fi

  echo "Attente de Guacamole (${i}/${ATTEMPTS}) sur le port ${PORT}..."
  sleep "${SLEEP_SECONDS}"
  i=$((i + 1))
done

echo "Guacamole n'a pas repondu sur http://localhost:${PORT}/ dans le delai imparti." >&2
exit 1
