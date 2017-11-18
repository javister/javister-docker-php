#!/usr/bin/env bash

mkdir -p /config/php-fpm/log
chown -R system:system /config/php-fpm
sed -i "s/^listen = .*/listen = ${HOSTIP}:9000/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^pm = .*/pm = ${FPM_PM}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^pm.max_children = .*/pm.max_children = ${FPM_PM_MAX_CHILDREN}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^pm.start_servers = .*/pm.start_servers = ${FPM_PM_START_SERVERS}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^pm.min_spare_servers = .*/pm.min_spare_servers = ${FPM_PM_MIN_SPARE_SERVERS}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^pm.max_spare_servers = .*/pm.max_spare_servers = ${FPM_PM_MAX_SPARE_SERVERS}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^;pm.process_idle_timeout = .*/pm.process_idle_timeout = ${FPM_PM_PROCESS_IDLE_TIMEOUT}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
sed -i "s/^;pm.max_requests = .*/pm.max_requests = ${FPM_PM_MAX_REQUESTS}/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf
