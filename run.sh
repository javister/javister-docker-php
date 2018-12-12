#!/bin/bash

## resolve links - $0 may be a link to ant's home
PRG="$0"

# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls="$(ls -ld "$PRG")"
  link="$(expr "$ls" : '.*-> \(.*\)$')"
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG="$(dirname "$PRG")/$link"
  fi
done

PROXY_ARGS="--env http_proxy=${http_proxy} \
            --env no_proxy=${no_proxy}"

WORK_DIR="$(dirname "$PRG")"
WORK_DIR="$(readlink -f ${WORK_DIR})/tmp"

mkdir -p ${WORK_DIR}
sync

GID="$(id -g)"

docker run -it --name php-fpm --env PUID=$UID --env PGID=${GID} -p 80:80 --rm ${PROXY_ARGS} -v ${WORK_DIR}:/config:rw javister-docker-docker.bintray.io/javister/javister-docker-php:72-1 $@
