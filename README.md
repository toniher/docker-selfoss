# docker-selfoss
Docker of selfoss RSS reader

* Run instance

      docker run --net=selfoss --restart unless-stopped -d -p 10025:80 -v /var/www/rsscau/conf/config.ini:/var/www/htdocs/config.ini -v /var/www/rsscau/data:/var/www/htdocs/data --name selfoss toniher/selfoss

* Cron

      10 */1 * * * docker exec selfoss php /var/www/htdocs/cliupdate.php &> /tmp/selfoss.log



