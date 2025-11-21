FROM ruby:3.4.5-slim

WORKDIR /usr/src/counter

COPY Gemfile Gemfile.lock ./
RUN bundle install

# COPY . .
