
ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="1.15.8.3-1-alpine"

FROM openresty/openresty:alpine
RUN apk add jq
COPY packages/lua-resty-http /lua-resty-http
RUN mkdir /app
WORKDIR /app
COPY api.lua /app
COPY app.conf /etc/nginx/conf.d/app.conf