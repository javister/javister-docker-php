FROM javister-docker-docker.bintray.io/javister/javister-docker-base:1.0
MAINTAINER Viktor Verbitsky <vektory79@gmail.com>

ARG PHP_VERSION="72"

COPY files /

ENV HOME="/app" \
    PHP_VERSION=${PHP_VERSION} \
    BASE_RPMLIST="${BASE_RPMLIST} php${PHP_VERSION}-php-cli php${PHP_VERSION}-php-fpm fcgi" \
    FPM_PM="dynamic" \
    FPM_PM_MAX_CHILDREN="50" \
    FPM_PM_START_SERVERS="5" \
    FPM_PM_MIN_SPARE_SERVERS="5" \
    FPM_PM_MAX_SPARE_SERVERS="35" \
    FPM_PM_PROCESS_IDLE_TIMEOUT="10s" \
    FPM_PM_MAX_REQUESTS="0"


RUN . /usr/local/sbin/yum-proxy && \
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-install && \
    sed -i "s/apache/system/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -ri "s/^(listen.allowed_clients = .*)/;\1/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^error_log = .*/error_log = \\/config\\/php-fpm\\/log\\/error.log/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.conf && \
    sed -ri "s/^;(pid = .*)/\1/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.conf && \
    sed -i "s/^;chdir = .*/chdir = \\/app/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^;pm.status_path = .*/pm.status_path = \\/status/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^;ping.path = .*/ping.path = \\/ping/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^;ping.response = .*/ping.response = pong/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^;access.log = .*/access.log = \\/config\\/php-fpm\\/log\\/access.log/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/^;catch_workers_output = .*/catch_workers_output = yes/g" /etc/opt/remi/php${PHP_VERSION}/php-fpm.d/www.conf && \
    yum-clean && \
    chmod --recursive --changes +x /etc/my_init.d/*.sh /etc/service /usr/local/bin

HEALTHCHECK --interval=15s --timeout=3s --start-period=30s \
    CMD ([ "$(SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect ${HOSTNAME}:9000 | grep -o "pong")" == "pong" ] && exit 0) || exit 1

EXPOSE 9000
