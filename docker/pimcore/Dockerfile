FROM ubuntu:22.04
LABEL ch.taywa.image.authors="ys@taywa.ch"
ENV DEBIAN_FRONTEND=noninteractive
ADD files.tar.gz /
RUN cp /etc/skel/.bashrc /etc/skel/.bash_aliases /root/ && \
    apt-get update -qqy && apt-get upgrade -qqy \
    && apt-get install -qqy apt-utils \
    && apt-get install -qqy --no-install-recommends \
    acl \
    busybox \
    ca-certificates \
    cmake \
    cron \
    curl \
    exiftool \
    ghostscript \
    git-core \
    graphicsmagick \
    graphviz \
    html2text \
    jpegoptim \
    jq \
    language-pack-de \
    lftp \
    locales \
    make \
    mariadb-client \
    moreutils \
    nasm \
    opencv-data \
    openjdk-11-jre-headless \
    openssh-server \
    php-apcu \
    php-bcmath \
    php-bz2 \
    php-cli \
    php-curl \
    php-dev \
    php-exif \
    php-fileinfo \
    php-fpm \
    php-gd \
    php-gd \
    php-intl \
    php-mbstring \
    php-mysql \
    php-opcache \
    php-pclzip \
    php-pear \
    php-redis \
    php-soap \
    php-xdebug \
    php-xml \
    php-xmlrpc \
    php-zip \
    pngcrush \
    poppler-utils \
    python3-pip \
    rsync \
    silversearcher-ag \
    ssmtp \
    sudo \
    unzip \
    xz-utils \
    zip unzip \
    wget \
    && rm /etc/ssh/ssh_host_*
# don't auto activate xdebug (slow)
RUN rm /etc/php/8.1/fpm/conf.d/20-xdebug.ini && rm /etc/php/8.1/cli/conf.d/20-xdebug.ini
RUN cd /usr/local/bin \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar composer \
    && ln -s /usr/local/bin/composer /usr/bin/composer
RUN locale-gen en_US.UTF-8 \
    && echo "Europe/Zurich" > /etc/timezone && ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 PATH=$PATH:/opt/pimcore/bin
ARG IMAGEMAGICK_VERSION=7.1.0-26
RUN apt-get update && apt-get install -qqy --no-install-recommends \
    bzip2 \
    facedetect \
    gsfonts \
    libde265-0 \
    libdjvulibre21 \
    libfftw3-bin \
    libfontconfig1 \
    libfreetype6 \
    libheif1 \
    libicu70 \
    libjpeg-turbo8 \
    liblcms2-2 \
    liblqr-1-0 \
    libltdl7 \
    liblzma5 \
    libonig5 \
    libopenexr25 \
    libopenjp2-7 \
    libopenjp2-7 \
    libpango-1.0-0 \
    libpng16-16 \
    librsvg2-2 \
    librsvg2-2 \
    libtiff5 \
    libwebp7 \
    libwmf0.2-7 \
    libxml2 \
    libxpm4 \
    libxslt1.1 \
    libzip4 \
    netpbm \
    optipng \
    pngquant \
    zlib1g \
    zopfli
RUN apt-get install -qqy --no-install-recommends \
    build-essential \
    checkinstall \
    libbz2-dev \
    libde265-dev \
    libdjvulibre-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libheif-dev \
    libicu-dev \
    libjpeg-turbo8-dev \
    liblcms2-dev \
    liblqr-1-0-dev \
    libltdl-dev \
    liblzma-dev \
    libonig-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libopenjp2-7-dev \
    libpango1.0-dev \
    libpng-dev \
    librsvg2-dev \
    librsvg2-dev \
    libtiff5-dev \
    libwebp-dev \
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
    && ldconfig /usr/local/lib \
    && echo "extension=imagick.so" > /etc/php/8.1/mods-available/imagick.ini \
    && phpenmod imagick \
    && yes ''|pecl install imagick \
    && rm -Rf /usr/local/src/ImageMagick* \
    && apt-get remove --purge -qqy \
    build-essential \
    checkinstall \
    libbz2-dev \
    libde265-dev \
    libdjvulibre-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libheif-dev \
    libicu-dev \
    libjpeg-turbo8-dev \
    liblcms2-dev \
    liblqr-1-0-dev \
    libltdl-dev \
    liblzma-dev \
    libonig-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libopenjp2-7-dev \
    libpango1.0-dev \
    libpng-dev \
    librsvg2-dev \
    librsvg2-dev \
    libtiff5-dev \
    libwebp-dev \
    libwebp-dev \
    libwmf-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
    zlib1g-dev \
    && apt-get autoremove -y --purge
RUN echo "EXTRA THUMBNAIL APPS"
RUN apt-get install -qqy --no-install-recommends \
    libreoffice \
    inkscape
ARG SKELETON_TAG=v11.1.0-RC1
RUN cd /opt && git clone --branch $SKELETON_TAG --depth=1 https://github.com/pimcore/skeleton /opt/pimcore \
    && cd /opt/pimcore \
    && rm -Rf .git \
    && mkdir -p /root/.composer
WORKDIR /opt/pimcore
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN echo "BASE SKELETON INSTALL"
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    cd /opt/pimcore && composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer install \
    && rm /root/.config/composer/auth.json
ARG PIMCORE_VERSION=11.1.6
RUN echo "REMOVE AUTO UPDATE FROM PIMCORE SCRIPTS"
RUN mv composer.json composer.jq.json \
    && jq 'del(.scripts["post-update-cmd"])' composer.jq.json > composer.json \
    && rm composer.jq.json
RUN cp composer.json composer.lock /opt/ \
    && cp composer.json /opt/composer.orig.json \
    && cp composer.lock /opt/composer.orig.lock \
    sed -i -e "s#pimcore\": \"\^11.1#pimcore\": \"$PIMCORE_VERSION#" composer.json
RUN sed -i -e "s#memory_limit = 128M#memory_limit = 512M#" /etc/php/8.1/fpm/php.ini \
    && sed -i -e "s#post_max_size = 8M#post_max_size = 50M#" /etc/php/8.1/fpm/php.ini \
    && sed -i -e "s#upload_max_filesize = 2M#upload_max_filesize = 50M#" /etc/php/8.1/fpm/php.ini
# s6 overlay
ARG S6_OVERLAY_VERSION=v3.2.1.0
ENV S6_STAGE2_HOOK=/etc/s6-overlay/services-setup.sh
ENV PATH="${PATH}:/command"
RUN wget -q -O - https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-noarch.tar.xz | \
    xzcat | tar x  --exclude=./*/*/*/*/*/*/*/*/legacy-cont-init  --exclude=./*/*/*/*/*/*/legacy-cont-init --exclude=./*/*/*/*/*/*/legacy-services --exclude=./*/*/*/*/*/*/*/*/legacy-services -C /
RUN wget -q -O -  https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-`arch`.tar.xz | \
    xzcat | tar x -C /
COPY s6-overlay /etc/s6-overlay
ADD files-01/fpm/pool.d /etc/php/8.1/fpm/pool.d
ENTRYPOINT ["/init"]
EXPOSE 80
