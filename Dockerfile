FROM openresty/openresty:alpine-fat
RUN luarocks install lua-resty-openidc

RUN apk add openssl
RUN openssl req -x509 -nodes -days 365 \
    -subj '/C=CA/ST=QC/O=Example/CN=example.com' \
    -addext 'subjectAltName=DNS:example.com' \
    -newkey 'rsa:2048' \
    -keyout '/etc/ssl/private/nginx.key' \
    -out    '/etc/ssl/certs/nginx.crt';

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./github_actions_oidc.lua /usr/local/openresty/nginx/conf/github_actions_oidc.lua
ENTRYPOINT ["nginx", "-g", "daemon off;"]