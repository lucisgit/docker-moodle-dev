docker-moodle-dev
=============

This repo contains a set of Dockerfiles for creating Moodle development
environment:

* [docker-moodle-apache-dev](https://github.com/lucisgit/docker-moodle-dev/tree/master/apache) This frontend image provides Apache with PHP libraries required for Moodle as well as clamav service. 
* [docker-moodle-cron-dev](https://github.com/lucisgit/docker-moodle-dev/tree/master/cron) This cron image provides PHP libraries required for Moodle and corresponding cronjob according to Moodle requirements.

The actual Moodle code needs to be mounted as host directory data volume. This
approach allows developer working with the code locally, but serving content
via Docker containers.

## Database

It is assumed that you have container for the database within the same
Docker bridge network, so that all containers in the dev environment can
access it. For PostgreSQL I suggest using [official
image](https://hub.docker.com/_/postgres/).

## Installation

See README inside each image directory or refer to image documentation on
Docker hub. It is advised to use Compose to simplify dev environment setup
and containers running.

## Compose

The enclosed compose file example is for running dev environment from the
current directory. It is assumed you have a clone of this repo, as compose
file is building images from subdirs rahter than using ones from Docker
hub. Make a copy of it, name it `docker-moodle-dev-compose.yml` (gitignore
is aware of this file) and adjust it according to your needs; at the very
least, change the code content path to your location
(`/home/username/git/moodle` is used in example). Also, two data volumes
are required and need to be created first: `moodledata` and `pgdata`.

