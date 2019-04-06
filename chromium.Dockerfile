FROM alpine:edge


RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --update --no-cache add mesa-egl mesa-gles libgcc libc-dev make gcc bash git nodejs  chromium@edge nss@edge git ttf-freefont udev && \
    rm -rf /var/cache/apk/*

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

EXPOSE 9515

ENTRYPOINT ["chromium-browser"]

CMD [ \
  "--log-level=0", \
  "--headless", \
  "--disable-gpu", \
  "--disable-software-rasterizer", \
  "--no-sandbox", \
  "--disable-dev-shm-usage" \
]
#   "--whitelisted-ips", \
#   "--disable-extensions", \
#   "--no-proxy-server", \
#   "--disable-gpu" \
# ]
