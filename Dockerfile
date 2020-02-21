FROM ruby:2.6-alpine
LABEL maintainer="georg@ledermann.dev"

RUN apk add --update --no-cache \
    build-base \
    git \
    nodejs-current \
    yarn

WORKDIR /app

# Install standard Node modules
COPY package.json yarn.lock /app/
RUN yarn install

# Install standard gems
COPY Gemfile* /app/
RUN bundle config --global frozen 1 && \
    bundle config --local build.sassc --disable-march-tune-native && \
    bundle install -j4 --retry 3

#### ONBUILD: Add triggers to the image, executed later while building a child image

# Install Ruby gems (for production only)
ONBUILD COPY Gemfile* /app/
ONBUILD RUN bundle install -j4 --retry 3

# Copy the whole application folder into the image
ONBUILD COPY . /app

# Build the site for production
ONBUILD ENV JEKYLL_ENV production
ONBUILD RUN bundle exec jekyll build
