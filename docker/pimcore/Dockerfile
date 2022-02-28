FROM ubuntu:22.04
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ADD files.tar /
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
        nasm \
        busybox \
        git-core \
        ca-certificates \
        mariadb-client \
        graphviz \
        locales \
        language-pack-de \
        libgv-php7 \
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
        php-gd \
        moreutils \
        silversearcher-ag \
        lftp \
        openssh-server \
    && rm /etc/ssh/ssh_host_*
RUN cd /usr/local/bin \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar composer \
    && ln -s /usr/local/bin/composer /usr/bin/composer
RUN locale-gen en_US.UTF-8 \
    && echo "Europe/Zurich" > /etc/timezone && ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 PATH=$PATH:/opt/pimcore/bin
ARG S6_OVERLAY_VERSION=v2.2.0.3
RUN curl -Ls -o /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-`arch|sed 's/x86_64/amd64/'`.tar.gz \
    && tar xfz /tmp/s6-overlay.tar.gz -C /  --exclude="./bin" \
    && tar xzf /tmp/s6-overlay.tar.gz  -C /usr ./bin \
    && rm -f /tmp/s6-overlay.tar.gz
# image layer
ENV IMAGEMAGICK_VERSION=7.1.0-26
RUN apt-get update && apt-get install -qqy --no-install-recommends \
        facedetect \
        zopfli \
        libwebp6 \
        libopenjp2-7 \
        librsvg2-2 \
        libde265-0 \
        bzip2 \
        libdjvulibre21 \
        libfftw3-bin \
        libfontconfig1 \
        libfreetype6 \
        libicu67 \
        libjpeg-turbo8 \
        liblcms2-2 \
        liblqr-1-0 \
        libltdl7 \
        liblzma5 \
        libonig5 \
        libopenexr25 \
        libopenjp2-7 \
        libpango-1.0-0 \
        libpng16-16 \
        librsvg2-2 \
        libtiff5 \
        libwmf0.2-7 \
        libxml2 \
        libxpm4 \
        libxslt1.1 \
        libzip4 \
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
    && echo "extension=imagick.so" > /etc/php/8.1/fpm/conf.d/30-imagick.ini \
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
    && ldconfig /usr/local/lib \
    && apt-get autoremove -y --purge

# EXTRA THUMBNAIL APPS
RUN apt-get install -qqy --no-install-recommends \
        libreoffice \
        inkscape

# EXTRA IMAGE OPTIMIZER LAYER
RUN curl -Ls -o /usr/local/bin/pngout https://github.com/imagemin/pngout-bin/raw/master/vendor/linux/x64/pngout \
&& chmod 0755 /usr/local/bin/*
ARG SKELETON_TAG=v10.1.9
ARG PIMCORE_VERSION=10.3.1
RUN cd /opt && git clone --branch $SKELETON_TAG --depth=1 https://github.com/pimcore/skeleton /opt/pimcore \
    && cd /opt/pimcore \
    && rm -Rf .git \
    && mkdir -p /root/.composer
WORKDIR /opt/pimcore
RUN sed -i -e "s#pimcore\": \"^10.0#pimcore\": \"$PIMCORE_VERSION#" composer.json
ENV COMPOSER_MEMORY_LIMIT=-1
# BASE SKELETON INSTALL
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    cd /opt/pimcore && composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer install \
    && rm /root/.config/composer/auth.json
# REMOVE AUTO UPDATE FROM PIMCORE SCRIPTS
RUN mv composer.json composer.jq.json \
    && jq 'del(.scripts["post-update-cmd"])' composer.jq.json > composer.json \
    && rm composer.jq.json
RUN cp composer.json composer.lock /opt/ \
    && cp composer.json /opt/composer.orig.json \
    && cp composer.lock /opt/composer.orig.lock
RUN sed -i -e "s#memory_limit = 128M#memory_limit = 512M#" /etc/php/8.1/fpm/php.ini \
    && sed -i -e "s#post_max_size = 8M#post_max_size = 50M#" /etc/php/8.1/fpm/php.ini \
    && sed -i -e "s#upload_max_filesize = 2M#upload_max_filesize = 50M#" /etc/php/8.1/fpm/php.ini
# fix quantity value unit, https://github.com/pimcore/pimcore/pull/9250/files
#ADD patches/0001-8300-Increase-query-column-and-column-format-to-varc.patch /tmp/
#RUN cd /opt/vendor/pimcore/pimcore && git apply /tmp/0001-8300-Increase-query-column-and-column-format-to-varc.patch
ADD files-01/nginx/http.conf /etc/nginx/conf.d/
ADD files-01/cron/pimcore /etc/cron.d/
ADD files-01/fpm/pool.d /etc/php/8.1/fpm/pool.d
ADD s6/etc/services.d /etc/services.d
ADD s6/etc/cont-init.d /etc/cont-init.d
ENTRYPOINT ["/init"]
EXPOSE 80
