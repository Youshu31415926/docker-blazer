FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

ENV RAILS_ENV='production'
ENV RACK_ENV='production'

COPY ./rails_app/Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --jobs 20 --retry 5 --without development test

RUN mkdir /blazer-app
WORKDIR /blazer-app
ADD ./rails_app /blazer-app

RUN RAILS_ENV=production bundle exec rake assets:precompile

CMD ["/bin/sh", "-c", "bundle exec rails s -p 3000 -b '0.0.0.0'"]
