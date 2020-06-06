# syntax=docker/dockerfile:experimental
FROM taywa/pimcore:6.6.5
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=0.6.2
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.composer/auth.json \
    && cd /opt/vendor/pimcore/ \
    && rm -Rf datahub \
    && curl -Ls -o /tmp/block-type.zip https://github.com/dpfaffenbauer/data-hub/archive/block-type.zip \
    && unzip /tmp/block-type.zip \
    && mv data-hub-block-type data-hub \
    && rm /tmp/block-type.zip

# ADD DATA-DEFINITIONS BUNDLE
ARG DATADEFINITIONS_VERSION=3.0.5
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require w-vision/data-definitions:$DATADEFINITIONS_VERSION \
    && rm /root/.composer/auth.json
