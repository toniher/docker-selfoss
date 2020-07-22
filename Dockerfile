FROM toniher/nginx-php:nginx-1.16-php-7.3

ARG SELFOSS_VERSION=2.19-664481d

RUN set -x; \
    apt-get update && apt-get -y upgrade;
RUN set -x; \
    apt-get install -y unzip php-sqlite3 php-mysql;
RUN set -x; \
    rm -rf /var/lib/apt/lists/*

# Starting processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

RUN echo 'max_execution_time = 300' >> /etc/php/7.3/fpm/conf.d/maxexectime.ini;

RUN mkdir -p /var/www/htdocs; chown -R www-data:www-data /var/www/htdocs

USER www-data

WORKDIR /var/www/htdocs

RUN cd /tmp; wget -c -t0 https://bintray.com/fossar/selfoss/download_file?file_path=selfoss-$SELFOSS_VERSION.zip -O selfoss-$SELFOSS_VERSION.zip
RUN unzip /tmp/selfoss-$SELFOSS_VERSION.zip -d /var/www/htdocs; mv /var/www/htdocs/selfoss/* /var/www/htdocs/; rm -rf /var/www/htdocs/selfoss/; rm /tmp/selfoss-$SELFOSS_VERSION.zip

RUN rm -rf data

VOLUME /var/www/htdocs/data

USER root
RUN mkdir -p /run/php

CMD ["/usr/bin/supervisord"]
