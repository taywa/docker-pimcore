# syntax=docker/dockerfile:experimental
FROM taywa/pimcore:6.8.8
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA-DEFINITIONS BUNDLE
ARG DATADEFINITIONS_VERSION=3.2.4
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require w-vision/data-definitions:$DATADEFINITIONS_VERSION \
    && rm /root/.config/composer/auth.json

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=0.6.3
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.config/composer/auth.json

# ADD TRANSLATION LIBS
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require aws/aws-sdk-php "3.155.1" \
    && composer require babymarkt/deepl-php-lib "v1.1.0" \
    && rm /root/.config/composer/auth.json
