# Dockerfile for creating web frontend container for Moodle development.
# See README.md for details.

# Using eboraas/debian as base image. Clean and minimalistic
# image based on debootstrapped version of Debian:jessie.
FROM eboraas/debian:jessie

MAINTAINER Ruslan Kabalin <r.kabalin@lancaster.ac.uk>

# Install PHP and modules Moodle needs for functioning
# (https://docs.moodle.org/31/en/PHP).
RUN apt-get update && apt-get install -y \
  cron \
  php5-cli \
  php5-xmlrpc \
  php5-intl \
  php5-curl \
  php5-gd \
  php5-xsl \
  php5-mysql \
  php5-pgsql \
  libreoffice \
  ghostscript \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Add backports and install unoconv
RUN awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y -t jessie-backports unoconv

# Move www-data home dir to the different location for security (it needs
# to be writable for unoconv to work).
RUN mkdir /home/www-data
RUN chown www-data:www-data /home/www-data
RUN usermod -d /home/www-data www-data

# Moodle data directory. Consider using data volume mounted at this path
# for data persistency.
RUN mkdir /srv/moodledata
RUN chown -R www-data:www-data /srv/moodledata;

# Install supervisord.
RUN apt-get update && apt-get install -y \
  supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Configure supervisord.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add crontab configuration.
ADD moodle-cron /etc/cron.d/moodle-cron
RUN chmod 0644 /etc/cron.d/moodle-cron

CMD ["/usr/bin/supervisord", "-n"]
