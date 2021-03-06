FROM mediawiki:1.33

RUN apt-get -qy update; apt-get -qy install --no-install-recommends unzip; apt-get -qy clean

COPY libs/ /var/www/libs/
COPY php/ /var/www/html/
RUN a2enmod rewrite && cd extensions && /var/www/libs/install-extensions

COPY [".openshift/action_hooks/LocalSettings.php", "/var/www/.openshift/action_hooks/"]
RUN cd .. && /var/www/libs/setup-localsettings && mv ./LocalSettings.php html/

WORKDIR /var/www/html
CMD ["/var/www/libs/docker-cmd"]
