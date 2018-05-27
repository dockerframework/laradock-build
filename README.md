# Laradock Build
Docker builder & running script for Laradock.

[![Build Status](https://travis-ci.org/dockerframework/laradock-build.svg?branch=master)](https://travis-ci.org/dockerframework/laradock-build) [![GitHub issues](https://img.shields.io/github/issues/dockerframework/laradock-build.svg)](https://github.com/dockerframework/laradock-build/issues) [![GitHub forks](https://img.shields.io/github/forks/dockerframework/laradock-build.svg)](https://github.com/dockerframework/laradock-build/network) [![GitHub stars](https://img.shields.io/github/stars/dockerframework/laradock-build.svg)](https://github.com/dockerframework/laradock-build/stargazers) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dockerframework/laradock-build/master/LICENSE)

## Configuration Environment
* Change `.env.example` file to `.env` for Docker environment configuration

## Setup Docker Builder Script
* Change docker build & running environment in `laradock.sh` file
  - ENV="0"  # (0 = development, 1 = production)
* Setup for containers
  - CONTAINER_PRODUCTION="consul portainer ..."     # (see `laradock.sh` for available containers)
  - CONTAINER_DEVELOPMENT="consul portainer"    # (using only 2 containers)
* Setup cache containers
  - REMOVE_CACHE="0" # (0 = using cache (default), 1 = no-cache)
* Setup recreate containers every running docker-compose
  - RECREATE_CONTAINER="0"  # (0 = disable recreate container, 1 = force recreate container)
* Setup running build containers or not.
  - SKIP_BUILD="0"   # (0 = with build process (default), 1 = bypass build process)
* Setup running background (daemon mode)
  - DAEMON_MODE="0"  # (0 = disable daemon mode, 1 = running daemon mode / background)

## Running Laradock Builder
You can run the command / terminal using bash to run docker
```
./laradock.sh
```
