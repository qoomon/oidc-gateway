#!/usr/bin/env sh
# exit when any command fails
set -e

openssl req -x509 -nodes -days 365 \
  -subj   '/C=CA/ST=QC/O=self-signed/CN=self-signed.local' \
  -addext 'subjectAltName=DNS:self-signed.local' \
  -newkey 'rsa:2048' \
  -keyout '/etc/ssl/private/nginx.key' \
  -out    '/etc/ssl/certs/nginx.crt'

exec nginx -g 'daemon off;'
