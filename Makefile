# -----------------------------------------------------------------------------
#  MAKEFILE RUNNING COMMAND
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  Repository : https://github.com/docker/docker
#  License    : MIT
# -----------------------------------------------------------------------------
# Notes:
# use [TAB] instead [SPACE]

PATH_SERVICES="./services"

#------------------------
# DocKube Services
#------------------------
docker-run:
	./docker-cmd.sh build

compose-build:
	./docker-cmd.sh compose-build $1

compose-up:
	./docker-cmd.sh compose-up

docker-stop:
	./docker-cmd.sh compose-stop

docker-down:
	./docker-cmd.sh compose-down
