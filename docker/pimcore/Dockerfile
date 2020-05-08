# syntax=docker/dockerfile:experimental
FROM ubuntu:20.04
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
# ARGS S6_OVERLAY_VERSION, SKELETON_TAG
ADD files.tar /
# BASE SOFTWARE LAYER
RUN cp /etc/skel/.bashrc /etc/skel/.bash_aliases /root/ && \
    apt-get update -qqy && apt-get upgrade -qqy \
    && apt-get install -qqy apt-utils \
    && apt-get install -qqy --no-install-recommends \
        curl \
        acl \
        sudo \
        make \
        unzip \
        cron \
        jq \
        busybox \
        git-core \
        ca-certificates \
        composer \
        mariadb-client \
        graphviz \
        locales \
        language-pack-de \
        libgv-php7 \
        libreoffice \
        poppler-utils \
        nginx-extras \
        html2text \
        ghostscript \
        pngcrush \
        jpegoptim \
        exiftool \
        opencv-data \
        php-gd \
        php-fpm \
        php-zip \
        php-curl \
        php-cli \
        php-mbstring \
        php-xml \
        php-mysql \
        php-intl \
        php-opcache \
        php-imagick \
        php-redis \
        php-apcu \
        php-bcmath \
        php-bz2 \
        php-soap \
        php-xmlrpc \
        php-fileinfo \
        php-exif \
        openjdk-11-jre-headless
RUN locale-gen en_US.UTF-8 \
    && echo "Europe/Zurich" > /etc/timezone && ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 PATH=$PATH:/opt/pimcore/bin COMPOSER_VENDOR_DIR=/opt/vendor
ARG S6_OVERLAY_VERSION=v1.22.1.0
RUN curl -Ls -o /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz \
    && tar xfz /tmp/s6-overlay.tar.gz -C /  --exclude="./bin" \
    && tar xzf /tmp/s6-overlay.tar.gz  -C /usr ./bin \
    && rm -f /tmp/s6-overlay.tar.gz
# EXTRA IMAGE OPTIMIZER LAYER
RUN curl -Ls -o /usr/local/bin/zopflipng https://github.com/imagemin/zopflipng-bin/raw/master/vendor/linux/zopflipng \
&& chmod 0755 /usr/local/bin/zopflipng \
&& curl -Ls -o /usr/local/bin/pngout https://github.com/imagemin/pngout-bin/raw/master/vendor/linux/x64/pngout \
&& chmod 0755 /usr/local/bin/pngout \
&& curl -Ls -o /usr/local/bin/advpng https://github.com/imagemin/advpng-bin/raw/master/vendor/linux/advpng \
&& chmod 0755 /usr/local/bin/advpng \
&& curl -Ls -o /usr/local/bin/cjpeg https://github.com/imagemin/mozjpeg-bin/raw/master/vendor/linux/cjpeg \
&& chmod 0755 /usr/local/bin/cjpeg
RUN mkdir -p /opt/pimcore /opt/vendor /opt/web \
    && setfacl -dR -m u:www-data:rwX /opt/var /opt/web \
    && setfacl -R -m u:www-data:rwX /opt/var /opt/web
WORKDIR /opt/pimcore
# v2.6.2 Pimcore 6.6.2
ARG SKELETON_TAG=v2.6.2
RUN git clone --branch $SKELETON_TAG --depth=1 https://github.com/pimcore/skeleton . \
    && rm -Rf .git \
    && mv web var bin /opt/ \
    && mkdir /opt/pimcore/var_classes /opt/var/classes_DataObject \
    && ln -s /opt/pimcore/var_classes /opt/var/classes \
    && ln -s /opt/var/classes_DataObject /opt/pimcore/var_classes/DataObject \
    && ln -s /opt/vendor /opt/pimcore/vendor \
    && ln -s /opt/pimcore/app /opt/app \
    && ln -s /opt/web /opt/pimcore/web \
    && ln -s /opt/var /opt/pimcore/var \
    && ln -s /opt/bin /opt/pimcore/bin \
    && mkdir -p /home/pimcore/.composer
# BASE SKELETON INSTALL
RUN --mount=type=secret,id=GITHUBTOKEN,uid=1000 --mount=type=cache,uid=1000,target=/home/pimcore/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && COMPOSER_MEMORY_LIMIT=-1 composer install \
    && rm /home/pimcore/.composer/auth.json
# ADD DATA HUB BUNDLE
RUN --mount=type=secret,id=GITHUBTOKEN,uid=1000 --mount=type=cache,uid=1000,target=/home/pimcore/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && COMPOSER_MEMORY_LIMIT=-1 composer require pimcore/data-hub:v0.6.1 \
    && rm /home/pimcore/.composer/auth.json
# ADD DATA-DEFINITIONS BUNDLE
RUN --mount=type=secret,id=GITHUBTOKEN,uid=1000 --mount=type=cache,uid=1000,target=/home/pimcore/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && COMPOSER_MEMORY_LIMIT=-1 composer require w-vision/data-definitions:^3.0 \
    && rm /home/pimcore/.composer/auth.json
# REMOVE AUTO UPDATE FROM PIMCORE SCRIPTS
RUN mv composer.json composer.jq.json \
    && jq 'del(.scripts["post-update-cmd"])' composer.jq.json > composer.json \
    && rm composer.jq.json
RUN cp composer.json composer.lock /opt/ \
    && cp composer.json /opt/composer.orig.json \
    && cp composer.lock /opt/composer.orig.lock
ENV COMPOSER_MEMORY_LIMIT=-1
RUN sed -i -e "s#memory_limit = 128M#memory_limit = 512M#" /etc/php/7.4/fpm/php.ini \
    && sed -i -e "s#post_max_size = 8M#post_max_size = 50M#" /etc/php/7.4/fpm/php.ini \
    && sed -i -e "s#upload_max_filesize = 2M#upload_max_filesize = 50M#" /etc/php/7.4/fpm/php.ini
ADD files-01/nginx/http.conf /etc/nginx/conf.d/
ADD files-01/cron/pimcore /etc/cron.d/
ADD s6/etc/services.d /etc/services.d
ADD s6/etc/cont-init.d /etc/cont-init.d
ENTRYPOINT ["/init"]
EXPOSE 80
