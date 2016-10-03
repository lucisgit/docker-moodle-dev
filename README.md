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
image](https://hub.docker.com/_/postgres/). To create database you can either create
container, access it via command line and create required user and database
inside, which you will then use in Moodle config.php (I prefer this
menthod, as you may need to create more than one DB for dev purposes, e.g
one for different version), or you may setup database and users using env
variables when Postgres container is created. It is a good idea to keep
Postgres data directory on the separate data volume, so that destroying
container will not destroy the data.

There are no rules here, pick the strategy that fits your needs and
development habits.

## Installation

See README inside each image directory or refer to image documentation on
Docker hub. It is advised to use Compose to simplify dev environment setup
and containers running.

## Docker Compose

The enclosed compose file example is for running dev environment from the
current directory. It is assumed you have a clone of this repo, as compose file
is building images from subdirs, rahter than using ones from Docker hub. Make a
copy of file, name it `docker-moodle-dev-compose.yml` (gitignore is aware of
this file) and adjust it according to your needs; at the very least, change the
code content path to your location (`/home/username/git/moodle` is used in
example). Also, two data volumes are required: `moodledata` (for Moodle data)
and `pgdata` (for Postgresql data) to make containers ephemeral. You need to
pre-create them before using compose file or asjust the file accordingly if you
are not using volumes.

To start environment using Docker compose in daemon mode use:
```bash
$ docker-compose -f docker-moodle-dev-compose.yml up -d
Creating network "dockermoodledev_default" with the default driver
Creating dockermoodledev_postgres_9.4_1
Creating dockermoodledev_moodle_1
```

You may check the status of containers using ps command:
```bash
$ docker-compose -f docker-moodle-dev-compose.yml ps
             Name                           Command               State              Ports             
------------------------------------------------------------------------------------------------------
dockermoodledev_moodle_1         /usr/bin/supervisord -n          Up      0.0.0.0:443->443/tcp, 80/tcp 
dockermoodledev_postgres_9.4_1   /docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
```

For more details on compose command please refer to its [documentaiton](https://docs.docker.com/compose/gettingstarted/).

### Note for Mac users

As there are some speed issues when host filesystem is mounted to
container, it is recommended to use
[docker-sync](https://github.com/EugenMayer/docker-sync) to speed up your
containers.

This repo includes `docker-sync-example.yml` file that needs to
be copied as `docker-sync.yml` (also git-ignored for convenience) and
adjusted for your needs (path to your local Moodle code repo at least).
Also, included `docker-moodle-dev-compose-sync_example.yml` shows how to adjust
compose file for docker-sync use.

Basically, the idea of docker-sync is continious syncing of your code changes
with the Docker volume created for this purposes (`moodlecode` in our example)
using isolated container. To initiate sync, use `docker-sync start` command. Once
sync has started, you may start development environment defined in
`docker-moodle-dev-compose.yml` using Compose, which will mount the volume-in-sync as Moodle
code containing directory (`/var/www/moodle`). You may monitor synced changes
in the console output where `docker-sync` is running.

