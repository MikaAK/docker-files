FROM mikaak/elixir:1.17-otp-27-debian

WORKDIR /home

ENV \
  PORT=4000 \
  REPLACE_OS_VARS=true \
  MIX_ENV=prod

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install nodejs npm -y && \
    rm -rf /var/lib/apt/lists/* && \
    mix local.hex --force && \
    mix local.rebar --force
