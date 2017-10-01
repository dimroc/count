FROM dimroc/docker-ruby-node
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --retry 2 --without development test
COPY . ./

# Make RAILS_ENV test just for asset compilation, to prevent connection to GCS.
RUN RAILS_ENV=test bundle exec rake assets:precompile

ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "bundle exec rails s" ]
EXPOSE 3000
