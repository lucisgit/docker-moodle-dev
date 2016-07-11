# Dockerfile for creating web frontend container for Moodle development.
# See README.md for details.

# Using eboraas/apache as base image. Clean and minimalistic
# image based on debootstrapped version of Debian:stable.
FROM eboraas/apache

MAINTAINER Ruslan Kabalin <r.kabalin@lancaster.ac.uk>

# Install PHP and modules Moodle needs for functioning
# (https://docs.moodle.org/31/en/PHP).
RUN apt-get update && apt-get install -y \
  php5 \
  libapache2-mod-php5 \
  php5-xmlrpc \
  php5-intl \
  php5-curl \
  php5-gd \
  php5-xsl \
  php5-mysql \
  php5-pgsql \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Make sure only mpm_prefork is enabled.
RUN /usr/sbin/a2dismod 'mpm_*' && /usr/sbin/a2enmod mpm_prefork

# Add Apache configuration.
ADD 000-moodle.conf /etc/apache2/sites-available/
ADD 001-moodle-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-moodle 001-moodle-ssl

# Moodle data directory. Consider using data volume mounted at this path
# for data persistency.
RUN mkdir /srv/moodledata
RUN chown -R www-data:www-data /srv/moodledata;

EXPOSE 80
EXPOSE 443

# Use running approach from official apache docker image, the script does
# necessary tasks before starting apache service.
COPY httpd-foreground /usr/local/bin/
RUN chmod 755 /usr/local/bin/httpd-foreground
CMD ["httpd-foreground"]
