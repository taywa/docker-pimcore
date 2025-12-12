#!/command/with-contenv sh

START_CRON=${START_CRON:-YES}
if [ "$START_CRON" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/cron
fi

START_NGINX=${START_NGINX:-NO}
if [ "$START_NGINX" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/nginx
fi

START_PHP_FPM=${START_PHP_FPM:-NO}
if [ "$START_PHP_FPM" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/php-fpm
fi

START_SSH=${START_SSH:-NO}
if [ "$START_SSH" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/ssh
fi

START_PIMCORE_MESSENGER_CONSUME=${START_PIMCORE_MESSENGER_CONSUME:-NO}
if [ "$START_PIMCORE_MESSENGER_CONSUME" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/pimcore-messenger-consume
fi

START_PIMCORE_CONSUME_ASSET_UPDATE=${START_PIMCORE_CONSUME_ASSET_UPDATE:-NO}
if [ "$START_PIMCORE_CONSUME_ASSET_UPDATE" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/pimcore-consume-asset-update
fi

START_PIMCORE_MAINTENANCE=${START_PIMCORE_MAINTENANCE:-NO}
if [ "$START_PIMCORE_MAINTENANCE" = "YES" ]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/pimcore-maintenance
fi
