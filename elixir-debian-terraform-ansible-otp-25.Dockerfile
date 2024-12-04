FROM mikaak/elixir-node:1.13-otp-25-debian

ENV OTP_VERSION="25.0" \
    REBAR_VERSION="2.6.4" \
    REBAR3_VERSION="3.18.0" \
    MIX_ENV="PROD"

# Terraform
RUN apt-get update -qq \
    && apt-get upgrade -y \
    && apt-get install -y ansible wget unzip \
    && rm -rf /var/lib/apt/lists/*

RUN TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'` \
    && wget -q https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip \
    && unzip terraform_${TER_VER}_linux_amd64.zip \
    && mv terraform /usr/local/bin/

# AWS CLI & Extras
RUN pip install awscli
RUN curl -sL https://sentry.io/get-cli/ | bash

CMD ["tail", "-f", "/dev/null"]
