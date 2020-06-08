# syntax=docker/dockerfile:experimental
FROM taywa/pimcore:6.6.4a
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
ARG DATAHUB_VERSION=0.6.2
ARG BLOCK_TYPE_VERSION=d4375239cadd70ee24b5dc086b9e32965987732e
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.composer/auth.json \
    && cd /opt/vendor/pimcore/ \
    && rm -Rf data-hub \
    && git clone --depth=1 --branch block-type https://github.com/dpfaffenbauer/data-hub \
    && cd data-hub \
    && git checkout $BLOCK_TYPE_VERSION \
    && rm -Rf data-hub/.git
