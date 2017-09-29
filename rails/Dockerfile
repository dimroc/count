FROM starefossen/ruby-node:2-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --retry 2
COPY . ./
RUN bundle exec rake assets:precompile

ENV RAILS_ENV production
ENV RACK_ENV production
ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "bundle exec rails s" ]
EXPOSE 3000
