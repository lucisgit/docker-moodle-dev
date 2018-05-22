# Dockerfile for creating cron container for Moodle development.
# See README.md for details.

# Using eboraas/debian as base image. Clean and minimalistic
# image based on debootstrapped version of Debian:stable.
FROM eboraas/debian:stable

LABEL maintainer="Ruslan Kabalin <r.kabalin@lancaster.ac.uk>"

# Install PHP and modules Moodle needs for functioning
# (https://docs.moodle.org/31/en/PHP).
RUN apt-get update && apt-get install -y \
  cron \
  php7.0-cli \
  php-xmlrpc \
  php-intl \
  php-curl \
  php-gd \
  php-xsl \
  php-mysql \
  php-pgsql \
  php-mbstring \
  php-soap \
  php-zip \
  && rm -rf /var/lib/apt/lists/*

# Install Unoconv and related packages.
RUN apt-get update && apt-get install -y \
  libreoffice \
  ghostscript \
  unoconv \
  && rm -rf /var/lib/apt/lists/*

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
  && rm -rf /var/lib/apt/lists/*

# Configure supervisord.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add crontab configuration.
ADD moodle-cron /etc/cron.d/moodle-cron
RUN chmod 0644 /etc/cron.d/moodle-cron

CMD ["/usr/bin/supervisord", "-n"]
