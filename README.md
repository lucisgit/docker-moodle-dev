docker-apache-php-moodle-dev
=============

This repo contains a Dockerfile for creating web frontend image for Moodle
development.  This simple frontend image provides Apache with PHP libraries
required for Moodle. The actual Moodle code needs to be mounted as host
directory data volume. This approach allows developer working with the code
locally, but serving content via Docker container.

## Database

It is assumed that you have container for the database within the same Docker
bridge network, so that web frontend can access it. For PostgreSQL I suggest
using [offical image](https://hub.docker.com/_/postgres/).

## Installation

Building image locally:

```bash
$ git clone https://github.com/lucisgit/docker-apache-php-moodle-dev.git
$ cd docker-apache-php-moodle-dev
$ docker build --rm -t lucisgit/docker-apache-php-moodle-dev .
```

## Using contrainer instance

In a very simple scenario you just need to create container instance and mount
your local Moodle directory (`/home/user/git/moodle` in example below) into the
container at `/var/www/moodle`:

```bash
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -d lucisgit/docker-apache-php-moodle-dev
```

The above command will start the container with mounted host directory
`/home/user/git/moodle` at `/var/www/moodle` in the container and map port 80
on the container to port 80 on the host.

## Moodle config.php

Your Moodle config.php should contain at least:

* Database host and credentials pointing to exising database container.
* `$CFG->dataroot  = '/srv/moodledata';`
* `$CFG->wwwroot   = 'http://localhost';`

## Moodle data persistance

You may wish to store Moodle data directory content oustide container, so that
it will not be destroyed on container re-creation. In order to do that, wou may use host
directory as data volume mounted at `/srv/moodledata` in the container:

```bash
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -v /home/user/moodledata:/srv/moodledata -d lucisgit/docker-apache-php-moodle-dev
```

Alternatively, create [Docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/) and use it in the container instance:

```bash
docker volume create --name moodledatavolume
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -v moodledatavolume:/srv/moodledata -d lucisgit/docker-apache-php-moodle-dev
```

## Using SSL

The image supports serving content by https using bundled "snakeoil" key. In
order to use it, you need to expose port 443 to the host and amend Moodle
config.php accordingly:

```bash
docker run --name dev-moodle-fe -p 443:443 -v /home/user/git/moodle:/var/www/moodle -d lucisgit/docker-apache-php-moodle-dev
```
> **Note:** To expose both ports 80 and 443 and map them to same ports or the host, just use `-P` paramenter instead of specifying port mapping. 

Your config.php should now use `$CFG->wwwroot   = 'https://localhost';`.

## Acessing Moodle container

Just enter http://localhost or https://localhost in your browser depending on
your settings.

## Credits

* Ed Boraas for minimalistic [apache image](https://hub.docker.com/r/eboraas/apache/) used as base here.
