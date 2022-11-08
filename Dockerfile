FROM openresty/openresty:alpine-fat
RUN apk add openssl
RUN luarocks install lua-resty-openidc

COPY ./entrypoint.sh /entrypoint.sh
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./github_actions_oidc.lua /usr/local/openresty/nginx/conf/github_actions_oidc.lua
ENTRYPOINT ["/entrypoint.sh"]