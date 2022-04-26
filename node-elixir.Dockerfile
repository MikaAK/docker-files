FROM elixir:1.13-alpine

WORKDIR /home

ENV \
  PORT=4000 \
  REPLACE_OS_VARS=true \
  MIX_ENV=prod

RUN apk update && \
    apk --no-cache --update add libgcc libc-dev make gcc openssl libstdc++ ncurses-libs bash git nodejs npm python3 && \
    rm -rf /var/cache/apk/* && \
    mix local.hex --force && \
    mix local.rebar --force
