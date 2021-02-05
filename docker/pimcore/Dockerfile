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
        python3-pip \
        cmake \
        unzip \
        cron \
        jq \
        busybox \
        git-core \
        ca-certificates \
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
        php-pclzip \
        php-pear \
        php-dev \
        php-xdebug \
        xz-utils \
        zip unzip \
        ssmtp \
        rsync \
        openjdk-11-jre-headless \
        graphicsmagick \
        inkscape \
        php-gd \
        imagemagick \
        moreutils \
        silversearcher-ag \
        lftp \
        openssh-server \
    && rm /etc/ssh/ssh_host_*
RUN cd /usr/local/bin \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar composer \
    && ln -s /usr/local/bin/composer /usr/bin/composer
RUN locale-gen en_US.UTF-8 \
    && echo "Europe/Zurich" > /etc/timezone && ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 PATH=$PATH:/opt/pimcore/bin COMPOSER_VENDOR_DIR=/opt/vendor
ARG S6_OVERLAY_VERSION=v2.1.0.2
RUN curl -Ls -o /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz \
    && tar xfz /tmp/s6-overlay.tar.gz -C /  --exclude="./bin" \
    && tar xzf /tmp/s6-overlay.tar.gz  -C /usr ./bin \
    && rm -f /tmp/s6-overlay.tar.gz
# image layer
ENV IMAGEMAGICK_VERSION=7.0.10-61
RUN apt-get update && apt-get install -qqy --no-install-recommends \
        libwebp6 \
        libopenjp2-7 \
        librsvg2-2 \
        libde265-0 \
        bzip2 \
        libdjvulibre21 \
        libfftw3-bin \
        libfontconfig1 \
        libfreetype6 \
        libicu66 \
        libjpeg-turbo8 \
        liblcms2-2 \
        liblqr-1-0 \
        libltdl7 \
        liblzma5 \
        libonig5 \
        libopenexr24 \
        libopenjp2-7 \
        libpango-1.0-0 \
        libpng16-16 \
        librsvg2-2 \
        libtiff5 \
        libwmf0.2-7 \
        libxml2 \
        libxpm4 \
        libxslt1.1 \
        libzip5 \
        zlib1g \
        netpbm \
        gsfonts
RUN apt-get install -qqy --no-install-recommends \
        build-essential \
        checkinstall \
        libwebp-dev \
        libopenjp2-7-dev \
        librsvg2-dev \
        libde265-dev \
        libbz2-dev \
        libdjvulibre-dev \
        libfftw3-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-turbo8-dev \
        liblcms2-dev \
        liblqr-1-0-dev \
        libltdl-dev \
        liblzma-dev \
        libonig-dev \
        libopenexr-dev \
        libopenjp2-7-dev \
        libpango1.0-dev \
        libpng-dev \
        librsvg2-dev \
        libtiff5-dev \
        libwebp-dev \
        libwmf-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        libzip-dev \
        zlib1g-dev \
    && curl -Ls -o /usr/local/src/ImageMagick.tar.gz https://github.com/ImageMagick/ImageMagick/archive/$IMAGEMAGICK_VERSION.tar.gz \
    && cd /usr/local/src && tar xf ImageMagick.tar.gz \
    && cd ImageMagick-$IMAGEMAGICK_VERSION \
    && ./configure \
    && make && make install \
    && pecl install imagick \
    && echo "extension=imagick.so" > /etc/php/7.4/fpm/conf.d/30-imagick.ini || true \
    && apt-get remove --purge -qqy \
        build-essential \
        checkinstall \
        libwebp-dev \
        libopenjp2-7-dev \
        librsvg2-dev \
        libde265-dev \
        libbz2-dev \
        libdjvulibre-dev \
        libfftw3-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-turbo8-dev \
        liblcms2-dev \
        liblqr-1-0-dev \
        libltdl-dev \
        liblzma-dev \
        libonig-dev \
        libopenexr-dev \
        libopenjp2-7-dev \
        libpango1.0-dev \
        libpng-dev \
        librsvg2-dev \
        libtiff5-dev \
        libwebp-dev \
        libwmf-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        libzip-dev \
        zlib1g-dev \
    && rm -Rf /usr/local/src/ImageMagick* \
    && ldconfig /usr/local/lib

# EXTRA IMAGE OPTIMIZER LAYER
RUN curl -Ls -o /usr/local/bin/zopflipng https://github.com/imagemin/zopflipng-bin/raw/master/vendor/linux/zopflipng \
&& curl -Ls -o /usr/local/bin/pngout https://github.com/imagemin/pngout-bin/raw/master/vendor/linux/x64/pngout \
&& curl -Ls -o /usr/local/bin/advpng https://github.com/imagemin/advpng-bin/raw/master/vendor/linux/advpng \
&& curl -Ls -o /usr/local/bin/cjpeg https://github.com/imagemin/mozjpeg-bin/raw/master/vendor/linux/cjpeg \
&& curl -Ls -o /usr/local/bin/facedetect  https://raw.githubusercontent.com/wavexx/facedetect/master/facedetect \
&& chmod 0755 /usr/local/bin/* \
&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get install -y nodejs \
&& npm install -g sqip
RUN mkdir -p /opt/pimcore /opt/vendor /opt/web
WORKDIR /opt/pimcore
ARG SKELETON_TAG=v2.8.11
ARG PIMCORE_VERSION=6.8.8
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
    && mkdir -p /root/.composer
RUN sed -i -e "s#pimcore\": \"~6.8.0#pimcore\": \"$PIMCORE_VERSION#" composer.json
ENV COMPOSER_MEMORY_LIMIT=-1
# BASE SKELETON INSTALL
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer install \
    && rm /root/.config/composer/auth.json
# REMOVE AUTO UPDATE FROM PIMCORE SCRIPTS
RUN mv composer.json composer.jq.json \
    && jq 'del(.scripts["post-update-cmd"])' composer.jq.json > composer.json \
    && rm composer.jq.json
RUN cp composer.json composer.lock /opt/ \
    && cp composer.json /opt/composer.orig.json \
    && cp composer.lock /opt/composer.orig.lock
RUN sed -i -e "s#memory_limit = 128M#memory_limit = 512M#" /etc/php/7.4/fpm/php.ini \
    && sed -i -e "s#post_max_size = 8M#post_max_size = 50M#" /etc/php/7.4/fpm/php.ini \
    && sed -i -e "s#upload_max_filesize = 2M#upload_max_filesize = 50M#" /etc/php/7.4/fpm/php.ini
ADD files-01/nginx/http.conf /etc/nginx/conf.d/
ADD files-01/cron/pimcore /etc/cron.d/
ADD files-01/fpm/pool.d /etc/php/7.4/fpm/pool.d
ADD s6/etc/services.d /etc/services.d
ADD s6/etc/cont-init.d /etc/cont-init.d
ENTRYPOINT ["/init"]
EXPOSE 80
