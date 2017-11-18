#!/bin/bash

sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/opt/remi/php${PHP_VERSION}/php.ini
sed -i -e "s#date.timezone.*#date.timezone = ${TZ}#g" /etc/opt/remi/php${PHP_VERSION}/php.ini
