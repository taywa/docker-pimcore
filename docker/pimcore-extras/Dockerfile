# syntax=docker/dockerfile:experimental
FROM taywa/pimcore:6.9.6b
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA-DEFINITIONS BUNDLE
ARG DATADEFINITIONS_VERSION=3.2.7
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require w-vision/data-definitions:$DATADEFINITIONS_VERSION \
    && rm /root/.config/composer/auth.json

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=1.0.8
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.config/composer/auth.json

# ADD MEMBERS BUNDLE
ARG MEMBERS_VERSION=3.1.0
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require dachcom-digital/members:$MEMBERS_VERSION \
    && rm /root/.config/composer/auth.json

# ADD TRANSLATION LIBS
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require aws/aws-sdk-php "3.193.2" \
    && composer require babymarkt/deepl-php-lib "v3.0.1" \
    && rm /root/.config/composer/auth.json

# ADD PHP JWT
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require firebase/php-jwt "v5.4.0" \
    && rm /root/.config/composer/auth.json

# ADD PHP php-units-of-measure
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 --mount=type=cache,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && jq '. += {"repositories": [{"type": "vcs", "url": "https://github.com/bgpack/php-units-of-measure", "name": "php-units-of-measure/php-units-of-measure"}]}' composer.json | sponge composer.json \
    && composer require --prefer-source "php-units-of-measure/php-units-of-measure" "v2.1.12" \
    && rm /root/.config/composer/auth.json

# update/fix layer
# udpate inkscape
RUN apt-get update \
    && apt-get install -qqy --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:inkscape.dev/stable \
    && apt-get update \
    && apt-get install -qqy --no-install-recommends inkscape \
    && apt-get remove --purge -y dbus dbus-user-session dconf-gsettings-backend dconf-service \
        gir1.2-packagekitglib-1.0 glib-networking glib-networking-common glib-networking-services \
        gsettings-desktop-schemas libappstream4 liblmdb0 libpackagekit-glib2-18 libpam-systemd \
        libpolkit-agent-1-0 libpolkit-gobject-1-0 libproxy1v5 libsoup2.4-1 libstemmer0d \
        libyaml-0-2 packagekit policykit-1 python3-apt python3-certifi python3-chardet python3-dbus python3-gi \
        python3-idna python3-requests python3-requests-unixsocket python3-six python3-software-properties \
        python3-urllib3 python-apt-common software-properties-common systemd-sysv \
    && apt-get clean

ADD files-00/cron/pimcore /etc/cron.d/
