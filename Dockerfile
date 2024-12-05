FROM toniher/nginx-php:nginx-1.23-php-8.1-sury

ARG SELFOSS_VERSION=2.20-1b2eeda

RUN set -x; \
  apt-get update && apt-get -y upgrade;
RUN set -x; \
  apt-get install -y unzip php8.1-sqlite3 php8.1-mysql;
RUN set -x; \
  rm -rf /var/lib/apt/lists/*

# Starting processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

COPY maxexectime.ini /etc/php/8.1/fpm/conf.d/maxexectime.ini

RUN mkdir -p /var/www/htdocs; chown -R www-data:www-data /var/www/htdocs

USER www-data

WORKDIR /var/www/htdocs

# Release version
# RUN cd /tmp; wget -c -t0 https://github.com/fossar/selfoss/releases/download/$SELFOSS_VERSION/selfoss-$SELFOSS_VERSION.zip
# Dev version
RUN cd /tmp; wget -c -t0 https://dl.cloudsmith.io/public/fossar/selfoss-git/raw/names/selfoss.zip/versions/$SELFOSS_VERSION/selfoss-$SELFOSS_VERSION.zip -O selfoss-$SELFOSS_VERSION.zip

RUN unzip /tmp/selfoss-$SELFOSS_VERSION.zip -d /var/www/htdocs; mv /var/www/htdocs/selfoss/* /var/www/htdocs/; rm -rf /var/www/htdocs/selfoss/; rm /tmp/selfoss-$SELFOSS_VERSION.zip

RUN rm -rf data

VOLUME /var/www/htdocs/data

USER root
RUN mkdir -p /run/php

CMD ["/usr/bin/supervisord"]
