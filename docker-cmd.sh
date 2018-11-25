#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  OPTION COMMAND - DOCKER BUILDER
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  Repository : https://github.com/zeroc0d3/docker-framework
#  License    : MIT
# -----------------------------------------------------------------------------

case $1 in

    build)
        echo "### Build All Container ###"
        ./docker-build.sh
        ;;

    compose-build)
        echo "### Spesific Build Container ###"
        docker-compose build $@
        ;;

    compose-up)
        echo "### Container Up ###"
        docker-compose up -d
        ;;

    compose-stop)
        echo "### Stop All Container ###"
        docker-compose stop -t 5
        ;;

    compose-down)
        echo "### Remove All Container ###"
        docker-compose down -t 5
        ;;

esac
