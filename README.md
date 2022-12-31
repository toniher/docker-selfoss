# docker-selfoss
Docker of selfoss RSS reader


## Run instance

      docker run --net=selfoss --restart unless-stopped -d -p 10025:80 -v /var/www/rsscau/conf/config.ini:/var/www/htdocs/config.ini -v /var/www/rsscau/data:/var/www/htdocs/data --name selfoss toniher/selfoss

Check config.ini details in: https://selfoss.aditu.de/

## Cron


### Via CLI


      15 */1 * * * docker exec selfoss php /var/www/htdocs/cliupdate.php &> /tmp/selfoss.log

### Via Web

Requires ```allow_public_update_access=true``` in config.ini

      15 */1 * * * curl -X GET https://rss.mydomain/update &> /tmp/selfoss.log

## Build

      docker build -t toniher/selfoss:latest .
