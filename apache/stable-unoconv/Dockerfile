# Dockerfile for creating web frontend container for Moodle development.
# See README.md for details.

# Using eboraas/debian as base image. Clean and minimalistic
# image based on debootstrapped version of Debian:stable.
FROM eboraas/debian:stable

MAINTAINER Ruslan Kabalin <r.kabalin@lancaster.ac.uk>

# Install Apache, PHP and modules Moodle needs for functioning
# (https://docs.moodle.org/33/en/PHP).
RUN apt-get update && apt-get install -y \
  apache2 \
  php7.0 \
  libapache2-mod-php7.0 \
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

# Prepare apache env.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Add Apache configuration.
ADD 000-moodle.conf /etc/apache2/sites-available/
ADD 001-moodle-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-moodle 001-moodle-ssl
ADD 30-moodle.ini /etc/php7/apache2/conf.d/

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

# Deploy clamav and freshclam init script.
COPY clamav-init /usr/local/bin/
RUN chmod 755 /usr/local/bin/clamav-init

# Add www-data to clamav group to permit using it, also add clamav user to
# www-data group for filesystem access.
RUN adduser www-data clamav && \
  adduser clamav www-data

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]
