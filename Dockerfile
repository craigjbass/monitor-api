FROM ruby:2.5.1-alpine3.7

RUN apk --no-cache add postgresql-dev postgresql-libs postgresql-client less

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN apk --no-cache add alpine-sdk && bundle install && apk del alpine-sdk

ADD . /app

EXPOSE 4567
