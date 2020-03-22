# syntax=docker/dockerfile:experimental
FROM ubuntu:19.10
MAINTAINER Yves Serrano <ys@taywa.ch>
ARG S6_OVERLAY_VERSION=v1.22.1.0
# v2.5.3. Pimcore 6.5.2
ARG SKELETON_TAG=v2.5.3
ENV DEBIAN_FRONTEND=noninteractive
ADD files.tar /
RUN cp /etc/skel/.bashrc /root/.bashrc && \
    apt-get update -qqy && apt-get upgrade -qqy \
    && apt-get install -qqy apt-utils \
    && apt-get install -qqy --no-install-recommends \
        curl \
        sudo \
        make \
        unzip \
        busybox \
        git-core \
        ca-certificates \
        php-fpm \
        php-zip \
        php-gd \
        php-curl \
        php-cli \
        php-mbstring \
        php-xml \
        php-mysql \
        php-intl \
        php-opcache \
        composer \
        mariadb-client \
        graphicsmagick \
        graphviz \
        locales \
        language-pack-de
RUN locale-gen en_US.UTF-8 \
    && echo "Europe/Zurich" > /etc/timezone && ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime \
    && sed -i -e "s#memory_limit = 128M#memory_limit = 512M#" /etc/php/7.3/fpm/php.ini
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 PATH=$PATH:/opt/pimcore/bin COMPOSER_VENDOR_DIR=/opt/vendor
RUN apt-get install -qqy --no-install-recommends nginx-extras
RUN curl -Ls -o /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz \
    && tar xfz /tmp/s6-overlay.tar.gz -C /  --exclude="./bin" \
    && tar xzf /tmp/s6-overlay.tar.gz  -C /usr ./bin \
    && rm -f /tmp/s6-overlay.tar.gz
RUN useradd -ms /bin/bash pimcore \
    && cp /etc/skel/.bashrc /home/pimcore/.bashrc \
    && usermod -a -G www-data pimcore \
    && mkdir -p /opt/pimcore /opt/vendor /opt/var /opt/web /opt/var \
    && chown -R pimcore:pimcore /opt/ /home/pimcore/.bashrc \
    && chown -R www-data:www-data /opt/web /opt/var
USER pimcore
WORKDIR /opt/pimcore
RUN git clone --branch $SKELETON_TAG --depth=1 https://github.com/pimcore/skeleton . \
    && rm -Rf .git \
    && mv web var /opt/ \
    && ln -s /opt/vendor /opt/pimcore/vendor \
    && ln -s /opt/pimcore/app /opt/app \
    && ln -s /opt/web /opt/pimcore/web \
    && ln -s /opt/var /opt/pimcore/var \
    && ln -s /opt/pimcore/bin /opt/bin \
    && mkdir -p /home/pimcore/.composer
RUN --mount=type=secret,id=GITHUBTOKEN,uid=1000 --mount=type=cache,uid=1000,target=/home/pimcore/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer install \
    && rm /home/pimcore/.composer/auth.json
USER root
RUN chown -R www-data:www-data /opt/web /opt/var
ADD s6/etc/services.d /etc/services.d
ADD s6/etc/cont-init.d /etc/cont-init.d
ENTRYPOINT ["/init"]

EXPOSE 8081
