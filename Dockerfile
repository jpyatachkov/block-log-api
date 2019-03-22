FROM ruby:2.6

RUN apt-get update && \
    apt-get install -qq -y build-essential libpq-dev nodejs postgresql-client --fix-missing --no-install-recommends

ENV RACK_ENV production
ENV RAILS_ENV production
ENV RAILS_ROOT /var/www/block-log-api

RUN mkdir -p $RAILS_ROOT shared/pids shared/sockets shared/log
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --binstubs --jobs 20 --retry 5 --without development test

COPY . .

EXPOSE 3000

CMD rake assets:precompile && bundle exec puma -C config/puma.rb
