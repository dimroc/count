FROM starefossen/ruby-node:2-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick

WORKDIR /app
COPY . ./
RUN bundle install --jobs 20 --retry 5
RUN bundle exec rake assets:precompile

ENV RAILS_ENV production
ENV RACK_ENV production
ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "bundle exec rails s" ]
