FROM elixir:1.7-alpine

ENV PATH=$HOME/.cargo/bin:$PATH

RUN mix local.hex --force && \
    mix local.rebar --force

RUN apk update && \
    apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --update --no-cache add libgcc libc-dev make gcc bash git udev rust cargo && \
    rm -rf /var/cache/apk/*

