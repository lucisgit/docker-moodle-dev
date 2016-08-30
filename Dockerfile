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

# Install supervisord and clamav.
RUN apt-get update && apt-get install -y \
  supervisor \
  clamav-daemon \
  clamav-freshclam \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Configure supervisord.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure clamav and freshclam.
RUN mkdir /var/run/clamav && \
  chown clamav:clamav /var/run/clamav && \
  chmod 750 /var/run/clamav

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

# Run virus database update. This will fetch antivirus base files, clamd
# will not start without them.
RUN freshclam

# Add www-data to clamav group to permit using it, also add clamav user to
# www-data group for filesystem access.
RUN adduser www-data clamav && \
  adduser clamav www-data

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]
