FROM elixir:1.8-alpine

ENV \
    PORT=4000 \
    REPLACE_OS_VARS=true \
    MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

RUN apk update && \
    apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --update --no-cache add libgcc libc-dev make gcc bash udev && \
    rm -rf /var/cache/apk/*

