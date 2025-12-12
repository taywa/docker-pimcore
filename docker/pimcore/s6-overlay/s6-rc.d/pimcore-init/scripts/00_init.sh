#!/bin/sh

if [ -d "/opt/pimcore/patches" ]; then
    cd /opt/pimcore
    for patchfile in $(find /opt/pimcore/patches -type f); do
        PATCHDIR=$(dirname $patchfile|sed 's#/opt/pimcore/patches/##')
        (patch -N -p1 --quiet --dry-run -d vendor/$PATCHDIR -i $patchfile && patch -p1 -d vendor/$PATCHDIR -i $patchfile) || true
    done
fi

if grep "mailhub=mail" "/etc/ssmtp/ssmtp.conf" 2>/dev/null; then
    echo "* configure ssmtp"
    sed -i \
        -e "s#mailhub=mail#mailhub=${MAILHUB:-localhost}#" \
        -e "s#\#FromLineOverride=YES#FromLineOverride=YES${MAILHUB:-localhost}#" \
        /etc/ssmtp/ssmtp.conf
fi

# update .env
PIMCORE_ENVIRONMENT=${PIMCORE_ENVIRONMENT:-dev}
if [ "$PIMCORE_ENVIRONMENT" = "dev" ]; then
    sed -i \
        -e "/^APP_ENV=/c\APP_ENV=dev" \
        -e "/^APP_DEBUG=/c\APP_DEBUG=true" \
        /opt/pimcore/.env
elif [ "$PIMCORE_ENVIRONMENT" = "prod" ]; then
    sed -i \
        -e "/^APP_ENV=/c\APP_ENV=prod" \
        -e "/^APP_DEBUG=/c\APP_DEBUG=false" \
        /opt/pimcore/.env
elif [ "$PIMCORE_ENVIRONMENT" = "prodtest" ]; then
    sed -i \
        -e "/^APP_ENV=/c\APP_ENV=prodtest" \
        -e "/^APP_DEBUG=/c\APP_DEBUG=false" \
        /opt/pimcore/.env
else
    sed -i \
        -e "/^APP_ENV=/c\APP_ENV=prod" \
        -e "/^APP_DEBUG=/c\APP_DEBUG=false" \
        /opt/pimcore/.env
fi

# make sure that default bundles exist
cd /opt/pimcore/public/bundles
ln -fs ../../vendor/friendsofsymfony/jsrouting-bundle/Resources/public/ fosjsrouting
ln -fs ../../vendor/pimcore/pimcore/bundles/ApplicationLoggerBundle/public/ pimcoreapplicationlogger
ln -fs ../../vendor/pimcore/pimcore/bundles/CoreBundle/public/ pimcorecore
ln -fs ../../vendor/pimcore/pimcore/bundles/SimpleBackendSearchBundle/public/ pimcoresimplebackendsearch
ln -fs ../../vendor/pimcore/admin-ui-classic-bundle/public/ pimcoreadmin

# make sure permissions are right
[ -d "/opt/pimcore/var" ] && find /opt/pimcore/var \( ! -uid 33 -o ! -gid 33 \) -execdir chown 33:33 {} +
[ -d "/opt/pimcore/public/var" ] && find /opt/pimcore/public/var \( ! -uid 33 -o ! -gid 33 \) -execdir chown 33:33 {} +
[ -d "/var/lib/php/sessions" ] && find /var/lib/php/sessions \( ! -uid 33 -o ! -gid 33 \) -execdir chown 33:33 {} +