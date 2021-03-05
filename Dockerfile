FROM ruby:2.7.0

# gem caching
ENV BUNDLE_PATH /bundle
ENV GEM_PATH /bundle
ENV GEM_HOME /bundle

ENV APP_HOME /referral_app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set up gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler --no-document
RUN bundle install
# add the rest of the project
COPY . ./

EXPOSE  3000
RUN chmod +x ./entrypoint
CMD ["./entrypoint"]
