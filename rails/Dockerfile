FROM dimroc/docker-ruby-node:latest
RUN (wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -) && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main\n" >> /etc/apt/sources.list.d/pgdg.list && \
  echo "deb http://security.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get remove libpq5 -y && \
      apt-get update -qq && \
      apt-get install -y build-essential libpq-dev libpq5 nodejs libssl1.0.0 \
      imagemagick postgresql-client-9.6

WORKDIR /app
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install --retry 2 --without development test
RUN yarn install

COPY . ./
RUN SECRET_KEY_BASE=bogus RAILS_ENV=production bundle exec rake assets:precompile

ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "bundle exec rails s" ]
EXPOSE 3000
