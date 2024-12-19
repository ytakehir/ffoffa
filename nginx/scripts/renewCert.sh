#!/bin/bash
docker run --rm \
  -v "$(pwd)/nginx/certs:/etc/letsencrypt" \
  certbot/certbot renew --quiet

# Nginxを再起動して更新を反映
docker restart nginx
