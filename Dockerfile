FROM openresty/openresty:alpine-fat
RUN adduser -D nginx
VOLUME  /usr/local/openresty/nginx/
RUN chown -R nginx:nginx /usr/local/openresty/nginx/

RUN apk add openssl && \
    luarocks install lua-resty-openidc

COPY ./entrypoint.sh /

WORKDIR /usr/local/openresty/nginx/
COPY ./nginx.conf              conf/
COPY ./github_actions_oidc.lua conf/

USER nginx
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]