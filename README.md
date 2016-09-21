docker-moodle-dev
=============

This repo contains a set of images for creating web frontend image for Moodle
development:

* docker-moodle-apache-dev This frontend image provides Apache with PHP libraries
required for Moodle as well as clamav service. 
* docker-moodle-cron-dev This cron image provides PHP libraries required for Moodle
  and corresponding cronjob according to Moodle requirements.

The actual Moodle code needs to be mounted as host directory data volume. This
approach allows developer working with the code locally, but serving content
via Docker container.

## Database

It is assumed that you have container for the database within the same Docker
bridge network, so that web frontend can access it. For PostgreSQL I suggest
using [offical image](https://hub.docker.com/_/postgres/).

## Installation

See README inside each image directory or refer to image documentation on Docker
hub.

## Compose

The enclosed compose file example is for running dev environment from the current
directory. It is assumed you have a clone of this repo, as compose file is
building images from subdirs rahter than using ones from Docker hub. It is
adviced to make a copy of it, name it `docker-moodle-dev-compose.yml`
(gitignore is aware of this file) and adjust it according to your needs; at
the very least, change the code content path to your location
(`/home/username/git/moodle` is used in example). Also, two data volumes are
required and need to be created first: `moodledata` and `pgdata`.


