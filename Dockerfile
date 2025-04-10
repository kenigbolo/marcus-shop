FROM ruby:3.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app/api
COPY ./api /app/api
RUN bundle install
CMD ["rails", "server", "-b", "0.0.0.0"]
