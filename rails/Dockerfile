FROM dimroc/docker-ruby-node
RUN (wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -) && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
      nodejs imagemagick postgresql-client-9.6

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --retry 2 --without development test
COPY . ./

# Make RAILS_ENV test just for asset compilation, to prevent connection to GCS.
RUN RAILS_ENV=test bundle exec rake assets:precompile

ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "bundle exec rails s" ]
EXPOSE 3000
