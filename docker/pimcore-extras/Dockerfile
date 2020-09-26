# syntax=docker/dockerfile:experimental
FROM taywa/pimcore:6.6.5
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA-DEFINITIONS BUNDLE
ARG DATADEFINITIONS_VERSION=3.0.5
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require w-vision/data-definitions:$DATADEFINITIONS_VERSION \
    && rm /root/.composer/auth.json

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=0.6.3
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.composer/auth.json

RUN apt-get update && apt-get install -qqy --no-install-recommends \
    graphicsmagick \
    inkscape \
    php-gd
