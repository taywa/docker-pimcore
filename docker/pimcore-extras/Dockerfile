FROM taywa/pimcore:10.5.11
MAINTAINER Yves Serrano <ys@taywa.ch>
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_MEMORY_LIMIT=-1

# ADD DATA HUB BUNDLE
ARG DATAHUB_VERSION=1.5.2
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require pimcore/data-hub:$DATAHUB_VERSION \
    && rm /root/.config/composer/auth.json

# ADD MEMBERS BUNDLE
ARG MEMBERS_VERSION=4.0.4
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require dachcom-digital/members:$MEMBERS_VERSION \
    && rm /root/.config/composer/auth.json

# ADD TRANSLATION LIBS
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require aws/aws-sdk-php "3.232.4" \
    && composer require babymarkt/deepl-php-lib "v4.0.0" \
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
    && composer require --prefer-source "php-units-of-measure/php-units-of-measure" "v2.1.12" \
    && rm /root/.config/composer/auth.json

# ADD phpfastcache
RUN --mount=type=secret,id=GITHUBTOKEN,uid=0 \
    --mount=type=cache,mode=0777,uid=0,target=/root/.composer/cache \
    composer config -g github-oauth.github.com $(cat /run/secrets/GITHUBTOKEN) \
    && composer require phpfastcache/phpfastcache:^8.1.3 psr/cache:^1.0.0 \
    && rm /root/.config/composer/auth.json
