FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --update --no-cache add openssl ncurses-libs libstdc++ && \
    rm -rf /var/cache/apk/*
# libgcc libc-dev make gcc bash udev
