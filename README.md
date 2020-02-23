![Build images](https://github.com/ledermann/docker-jekyll-base/workflows/Build%20image/badge.svg)

# DockerJekyllBase

Building Docker images usually takes a long time. This repo contains base images with preinstalled dependencies for [Jekyll](https://jekyllrb.com/), so building a production image will be **a lot faster**.

This project is the small sister of [DockerRailsBase](https://github.com/ledermann/docker-rails-base), which was created to do the same for Ruby on Rails.


## What?

When using the official Ruby image, building a Docker image for a typical Jekyll site requires lots of time for installing dependencies - mainly Ruby gems. This is required every time the site needs to be deployed to production.

I was looking for a way to reduce this time, so I created a base image that contain most of the dependencies used in my sites.


### Staying up-to-date

Using [Dependabot](https://dependabot.com/), every updated Ruby gem or Node module will lead to an updated image.


### Usage example

```Dockerfile
FROM ledermann/jekyll-base AS Builder
RUN bundle exec jekyll build
RUN bundle exec htmlproofer ./_site --disable-external

# Production with Nginx
FROM nginx:stable-alpine
COPY --from=Builder /app/_site /usr/share/nginx/html
COPY _nginx/nginx.conf /etc/nginx/conf.d/default.conf
```
