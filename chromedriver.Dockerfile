FROM alpine:edge

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk --no-cache upgrade && \
    apk --update --no-cache add wget chromium-chromedriver chromium@edge nss@edge && \
    rm -rf /var/cache/apk/*

EXPOSE 9515

ENTRYPOINT ["chromedriver"]

CMD [ \
  "--disable-extensions", \
  "--no-proxy-server", \
  "--disable-software-rasterizer", \
  "--disable-gpu", \
  "--headless", \
  "--no-sandbox", \
  "--whitelisted-ips" \
]
