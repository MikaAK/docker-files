FROM buildpack-deps:bullseye

ENV OTP_VERSION="25.0.4" \
    MIX_ENV="PROD" \
    RUNTIME_DEPS="libodbc1 libsctp1 libwxgtk3.0" \
    BUILD_DEPS="unixodbc-dev libsctp-dev" \
    OTP_DOWNLOAD_SHA256="05878cb51a64b33c86836b12a21903075c300409b609ad5e941ddb0feb8c2120"

LABEL org.opencontainers.image.version=$OTP_VERSION

RUN set -xe \
  && apt-get update \
  && apt-get install -y --no-install-recommends $RUNTIME_DEPS $BUILD_DEPS \
  && echo "deb http://ftp.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list \
  && echo "deb-src http://ftp.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y -t bullseye-backports libwxgtk-webview3.0-gtk3-dev \
  && apt-get install -y python3-pip jq \
  && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
  && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
  && echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
  && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
  && mkdir -vp $ERL_TOP \
  && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
  && rm otp-src.tar.gz \
  && ( cd $ERL_TOP \
    && ./otp_build autoconf \
    && GNU_ARCH="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
    && ./configure --build="$GNU_ARCH" --disable-jit \
    && make -j$(nproc) \
    && make -j$(nproc) docs DOC_TARGETS=chunks \
    && make install install-docs DOC_TARGETS=chunks) \
  && find /usr/local -name examples | xargs rm -rf \
  && apt-get purge -y --auto-remove $BUILD_DEPS \
  && rm -rf $ERL_TOP /var/lib/apt/lists/*

CMD ["erl"]

# extra useful tools here: rebar & rebar3
ENV REBAR_VERSION="2.6.4" \
    REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"

RUN set -xe \
  && REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz" \
  && mkdir -p /usr/src/rebar-src \
  && curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
  && echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
  && tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
  && rm rebar-src.tar.gz \
  && cd /usr/src/rebar-src \
  && ./bootstrap \
  && install -v ./rebar /usr/local/bin/ \
  && rm -rf /usr/src/rebar-src

ENV REBAR3_VERSION="3.19.0" \
    REBAR3_DOWNLOAD_SHA256="ff9ef42c737480477ebdf0dd9d95ece534a14c96f05edafbf32e9af973280bc3"

RUN set -xe \
  && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
  && mkdir -p /usr/src/rebar3-src \
  && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
  && echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
  && tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
  && rm rebar3-src.tar.gz \
  && cd /usr/src/rebar3-src \
  && HOME=$PWD ./bootstrap \
  && install -v ./rebar3 /usr/local/bin/ \
  && rm -rf /usr/src/rebar3-src

ENV ELIXIR_DOWNLOAD_SHA256="95daf2dd3052e6ca7d4d849457eaaba09de52d65ca38d6933c65bc1cdf6b8579" \
    ELIXIR_VERSION="v1.13.4" \
    LANG="C.UTF-8"

RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean \
  && find /usr/local/src/elixir/ -type f -not -regex "/usr/local/src/elixir/lib/[^\/]*/lib.*" -exec rm -rf {} + \
  && find /usr/local/src/elixir/ -type d -depth -empty -delete
