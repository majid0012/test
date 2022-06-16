FROM majidwatto/rails-app

ARG BUNDLER_VERSION=2.2.31

ENV PATH /app/bin:$PATH
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

COPY ./Gemfile ./Gemfile.lock ./package.json /my-app/

WORKDIR /my-app

RUN yarn install

COPY . /my-app
