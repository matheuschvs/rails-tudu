FROM ruby:3.0.0

RUN apt update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

ADD . /app
