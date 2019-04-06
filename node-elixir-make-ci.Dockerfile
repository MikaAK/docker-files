FROM elixir:1.7-alpine

WORKDIR /home

ENV \
  PORT=4000 \
  REPLACE_OS_VARS=true \
  MIX_ENV=prod \
  CHROME_BIN=/usr/bin/chromium-browser \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --update --no-cache add libgcc libc-dev make gcc bash git nodejs nodejs-npm chromium@edge nss@edge git ttf-freefont udev && \
    rm -rf /var/cache/apk/* && \
    mix local.hex --force && \
    mix local.rebar --force
