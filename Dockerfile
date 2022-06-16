FROM majidwatto/rails-app

ARG BUNDLER_VERSION=2.2.31

RUN apk update && \
    apk add \
    build-base \
    gnupg \
    curl \
    less \
    git \
    tzdata

RUN apk add --update --no-cache postgresql-dev python2 \
    pkgconfig imagemagick6 imagemagick6-dev imagemagick6-libs \
    imagemagick


RUN apk add nodejs --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/v3.10/main/"
RUN apk add npm --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/v3.10/main/"
RUN apk add yarn --no-cache

RUN apk update && \
    apk add --update --no-cache chromium \
    chromium-chromedriver python3 python3-dev py3-pip \
    libnotify-dev vim

RUN apk add --update --no-cache --wait 10 \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libssl1.1 \
    ca-certificates \
    fontconfig \
    freetype \
    ttf-dejavu \
    ttf-droid \
    ttf-freefont \
    ttf-liberation \
    ttf-ubuntu-font-family \
    && apk add --update --no-cache --virtual .build-deps \
    msttcorefonts-installer postgresql-client

RUN apk add && apk add postgresql-client

RUN apk add postgresql postgresql-contrib postgresql-dev
RUN su - postgres -c "initdb /var/lib/postgresql/data"
RUN mkdir /run/postgresql/
RUN chmod 777 /run/postgresql/

# Only needed for local dev and SSH into servers, we can probably remove
# once we've removed subspace and jeffries tube
RUN apk update && \
    apk add --update --no-cache openssh

# Only needed for Ansible/Subspace
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo
RUN pip3 install 'ansible==2.8.20'

# Only needed for awscli
RUN pip install awscli

RUN pip3 install -U selenium

ENV PATH /app/bin:$PATH
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

COPY ./Gemfile ./Gemfile.lock ./package.json /my-app/

WORKDIR /my-app

RUN yarn install

COPY . /my-app

RUN bundle install
