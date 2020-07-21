FROM toniher/nginx-php:nginx-1.14-php-7.0

ARG SELFOSS_VERSION=2.18

RUN set -x; \
    apt-get update && apt-get -y upgrade;
RUN set -x; \
    apt-get install -y unzip php-sqlite3 php-mysql;
RUN set -x; \
    rm -rf /var/lib/apt/lists/*

# Starting processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/htdocs; chown -R www-data:www-data /var/www/htdocs

USER www-data

WORKDIR /var/www/htdocs

RUN cd /tmp; wget -c -t0 https://github.com/SSilence/selfoss/releases/download/2.18/selfoss-$SELFOSS_VERSION.zip
RUN unzip /tmp/selfoss-$SELFOSS_VERSION.zip -d /var/www/htdocs

RUN rm -rf data

VOLUME /var/www/htdocs/data

USER root
RUN mkdir -p /run/php

CMD ["/usr/bin/supervisord"]
