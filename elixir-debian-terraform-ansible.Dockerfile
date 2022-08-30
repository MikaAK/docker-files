FROM mikaak/elixir:1.13-otp25-debian

ENV OTP_VERSION="25.0" \
    REBAR_VERSION="2.6.4" \
    REBAR3_VERSION="3.18.0" \
    MIX_ENV="PROD"

RUN pip install awscli
RUN curl -sL https://sentry.io/get-cli/ | bash


# Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && gpg --no-default-keyring \
           --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
           --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bullseye main" \
    | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update -qq \
 && apt-get upgrade -y

RUN apt-get install -y ansible terraform \
    && rm -rf /var/lib/apt/lists/*

RUN pip install awscli
RUN curl -sL https://sentry.io/get-cli/ | bash

CMD ["tail", "-f", "/dev/null"]
