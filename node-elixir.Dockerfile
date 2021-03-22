FROM elixir:1.11-alpine

WORKDIR /home

ENV \
  PORT=4000 \
  REPLACE_OS_VARS=true \
  MIX_ENV=prod

RUN apk update && \
    apk --no-cache --update add libgcc libc-dev make gcc bash git nodejs nodejs-npm && \
    rm -rf /var/cache/apk/* && \
    mix local.hex --force && \
    mix local.rebar --force
