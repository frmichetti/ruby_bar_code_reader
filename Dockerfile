FROM ruby:3.1-alpine

# RUN apk add ruby-dev
RUN apk add libmagickwand-dev
RUN apk add ghostscript
RUN apk add cmake
RUN apk add imagemagick 

# ENV BUNDLER_VERSION='2.0'
ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN bundle install

ADD . $APP_HOME