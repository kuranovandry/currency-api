FROM ruby:3.0.2-alpine

RUN apk update && apk add bash build-base nodejs postgresql-dev tzdata

RUN mkdir /currency-api
WORKDIR /currency-api

ENV BUNDLER_VERSION=2.2.22

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v ${BUNDLER_VERSION} --no-document
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . .

RUN mkdir -p /app/tmp/pids && \
  cp .env.example .env && \
  cp ./config/database.example.yml ./config/database.yml && \
  cp ./config/sidekiq.example.yml ./config/sidekiq.yml && \
  cp ./config/storage.example.yml ./config/storage.yml && \
  cp ./config/secrets.example.yml ./config/secrets.yml

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
