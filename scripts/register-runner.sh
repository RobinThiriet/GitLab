#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <runner-token>"
  exit 1
fi

TOKEN="$1"

docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --url http://gitlab \
  --token "$TOKEN" \
  --executor docker \
  --docker-image alpine:3.20 \
  --description docker-runner \
  --docker-privileged \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock
