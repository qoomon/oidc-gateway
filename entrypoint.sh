#!/usr/bin/env sh
# exit when any command fails
set -e

cd '/usr/local/openresty/nginx/conf/'

mkdir -p 'ssl/' && cd 'ssl/'
openssl req -x509 -nodes -days 365 \
  -subj   '/C=CA/ST=QC/O=self-signed/CN=self-signed.local' \
  -addext 'subjectAltName=DNS:self-signed.local' \
  -newkey 'rsa:2048' \
  -keyout 'self-signed.local.key' \
  -out    'self-signed.local.crt'

exec "$@"
