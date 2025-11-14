FROM taywa/pimcore:10.6.9
LABEL ch.taywa.image.authors="ys@taywa.ch"
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=1.7.5
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.config/composer/auth.json

# ADD MEMBERS BUNDLE
ARG MEMBERS_VERSION=4.1.2
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require dachcom-digital/members:$MEMBERS_VERSION \
    && rm /root/.config/composer/auth.json

# # ADD TRANSLATION LIBS
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require aws/aws-sdk-php "3.359.12" \
    && composer require babymarkt/deepl-php-lib "v4.0.0" \
    && composer require deeplcom/deepl-php "v1.14.0" \
    && rm /root/.config/composer/auth.json

# ADD PHP JWT
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require firebase/php-jwt "v6.3.0" \
    && rm /root/.config/composer/auth.json

# ADD PHP php-units-of-measure
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && jq '. += {"repositories": [{"type": "vcs", "url": "https://github.com/bgpack/php-units-of-measure", "name": "php-units-of-measure/php-units-of-measure"}]}' composer.json | sponge composer.json \
    && composer require --prefer-source "php-units-of-measure/php-units-of-measure" "v2.1.19" \
    && rm /root/.config/composer/auth.json

# ADD requirements for release management
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require league/commonmark:2.4.2 league/html-to-markdown:4.10.0 jfcherng/php-diff:6.16.2 \
    && rm /root/.config/composer/auth.json

ADD files-00/etc/gitconfig /etc/gitconfig
