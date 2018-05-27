#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  DOCKER BUILDER SCRIPT
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  Repository : https://github.com/zeroc0d3/docker-framework
#  License    : MIT
# -----------------------------------------------------------------------------

TITLE="LARADOCK BUILDER SCRIPT"      # script name
VER="1.4.1"                          # script version
ENV="0"                              # container environment (0 = development, 1 = production)
SKIP_BUILD="0"                       # (0 = with build process, 1 = bypass build process)
REMOVE_CACHE="0"                     # (0 = using cache, 1 = no-cache)
RECREATE_CONTAINER="0"               # (0 = disable recreate container, 1 = force recreate container)
DAEMON_MODE="1"                      # (0 = disable daemon mode, 1 = running daemon mode / background)

USERNAME=`echo $USER`
PATH_HOME=`echo $HOME`

##  LIST CONTAINER NAME & PORTS
## +==========+===========+==================================+
## |   PORT   |  DEFAULT  |  CONTAINER NAME                  |
## +==========+===========+==================================+
## |   8100   |    8080   |  adminer                         |
## +----------+-----------+----------------------------------+
## |   8101   |    3000   |  aerospike - service             |
## |   8102   |    3001   |  aerospike - fabric              |
## |   8103   |    3002   |  aerospike - heartbeat           |
## |   8104   |    3003   |  aerospike - info                |
## +----------+-----------+----------------------------------+
## |   8105   |      80   |  apache2                         |
## +----------+-----------+----------------------------------+
## |   8106   |    9200   |  elasticsearch                   |
## |   8107   |    9300   |                                  |
## +----------+-----------+----------------------------------+
## |   8108   |    3306   |  mariadb                         |
## |   8109   |    3306   |  mysql                           |
## |   8110   |    3306   |  percona                         |
## +----------+-----------+----------------------------------+
## |   8111   |   11211   |  memcached                       |
## +----------+-----------+----------------------------------+
## |   8112   |   27017   |  mongodb                         |
## +----------+-----------+----------------------------------+
## |   8113   |      80   |  nginx                           |
## +----------+-----------+----------------------------------+
## |   8114   |      80   |  pgadmin                         |
## +----------+-----------+----------------------------------+
## |   8115   |      80   |  phpfpm (only) - workspace       |
## |   8116   |    9090   |  phpfpm (only) - xdebug          |
## +----------+-----------+----------------------------------+
## |   8117   |      80   |  phpmyadmin                      |
## +----------+-----------+----------------------------------+
## |   8118   |    9000   |  portainer                       |
## +----------+-----------+----------------------------------+
## |   8119   |    5432   |  postgresql                      |
## +----------+-----------+----------------------------------+
## |   8120   |    6379   |  redis                           |
## +----------+-----------+----------------------------------+
## |   8121   |      22   |  ruby                            |
## +----------+-----------+----------------------------------+
## |   8122   |    8983   |  solr                            |
## +----------+-----------+----------------------------------+
## |   8123   |    8080   |  spark - master                  |
## |   8124   |    8881   |  spark - worker                  |
## +----------+-----------+----------------------------------+
## |   8125   |      22   |  terraform                       |
## +----------+-----------+----------------------------------+
## |   8126   |      22   |  vim                             |
## +----------+-----------+----------------------------------+
## |   8901   |      80   |  workspace phpfpm                |
## |   8902   |    9090   |  Workspace xdebug                |
## +----------+-----------+----------------------------------+
##  Required (must included)
##  - Container "consul"
##  - Container "portainer"

CONTAINER_PRODUCTION="consul workspace nginx adminer aerospike elasticsearch mariadb memcached mongodb mysql percona pgadmin phpfpm phpmyadmin portainer postgresql redis solr spark terraform"
CONTAINER_DEVELOPMENT="consul portainer"

export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300

get_time() {
  DATE=`date '+%Y-%m-%d %H:%M:%S'`
}

logo() {
  clear
  echo "\033[22;32m=======================================================================================\033[0m"
  echo "\033[22;31m '##::::::::::'###::::'########:::::'###::::'########:::'#######:::'######::'##:::'##: \033[0m"
  echo "\033[22;31m  ##:::::::::'## ##::: ##.... ##:::'## ##::: ##.... ##:'##.... ##:'##... ##: ##::'##:: \033[0m"
  echo "\033[22;31m  ##::::::::'##:. ##:: ##:::: ##::'##:. ##:: ##:::: ##: ##:::: ##: ##:::..:: ##:'##::: \033[0m"
  echo "\033[22;31m  ##:::::::'##:::. ##: ########::'##:::. ##: ##:::: ##: ##:::: ##: ##::::::: #####:::: \033[0m"
  echo "\033[22;31m  ##::::::: #########: ##.. ##::: #########: ##:::: ##: ##:::: ##: ##::::::: ##. ##::: \033[0m"
  echo "\033[22;31m  ##::::::: ##.... ##: ##::. ##:: ##.... ##: ##:::: ##: ##:::: ##: ##::: ##: ##:. ##:: \033[0m"
  echo "\033[22;31m  ########: ##:::: ##: ##:::. ##: ##:::: ##: ########::. #######::. ######:: ##::. ##: \033[0m"
  echo "\033[22;31m ........::..:::::..::..:::::..::..:::::..::........::::.......::::......:::..::::..:: \033[0m"
  echo "\033[22;32m---------------------------------------------------------------------------------------\033[0m"
  echo "\033[22;32m# $TITLE :: ver-$VER                                                                   \033[0m"
}

header() {
  logo
  echo "\033[22;32m=======================================================================================\033[0m"
  get_time
  echo "\033[22;31m# BEGIN PROCESS..... (Please Wait)  \033[0m"
  echo "\033[22;31m# Start at: $DATE  \033[0m\n"
}

footer() {
  echo "\033[22;32m=======================================================================================\033[0m"
  get_time
  echo "\033[22;31m# Finish at: $DATE  \033[0m"
  echo "\033[22;31m# END PROCESS.....  \033[0m\n"
}

build_env() {
  if [ "$ENV" = "0" ]
  then
    BUILD_ENV="$CONTAINER_DEVELOPMENT"
  else
    BUILD_ENV="$CONTAINER_PRODUCTION"
  fi
}

cache() {
  if [ "$REMOVE_CACHE" = "0" ]
  then
    CACHE=""
  else
    CACHE="--no-cache "
  fi
}

recreate() {
  if [ "$RECREATE_CONTAINER" = "0" ]
  then
    RECREATE=""
  else
    RECREATE="--force-recreate "
  fi
}

daemon_mode() {
  if [ "$DAEMON_MODE" = "0" ]
  then
    DAEMON=""
  else
    DAEMON="-d "
  fi
}

docker_build() {
  if [ "$SKIP_BUILD" = "0" ]
  then
    echo "--------------------------------------------------------------------------"
    get_time
    echo "\033[22;34m[ $DATE ] ##### Docker Compose: \033[0m                        "
    echo "\033[22;32m[ $DATE ]       docker-compose build $CACHE$BUILD_ENV \033[0m\n"

    ## MULTI CONTAINER
    ## ------------------------------
    for CONTAINER in $BUILD_ENV
    do
      get_time
      echo "--------------------------------------------------------------------------"
      echo "\033[22;32m[ $DATE ]       docker-compose build $CONTAINER \033[0m        "
      echo "--------------------------------------------------------------------------"
      docker-compose build $CONTAINER
      echo ""
    done

    ## SINGLE CONTAINER (test)
    ## ------------------------------
    ## get_time
    ## echo "--------------------------------------------------------------------------"
    ## echo "\033[22;32m[ $DATE ]       docker-compose build $BUILD_ENV \033[0m        "
    ## echo "--------------------------------------------------------------------------"
    ## docker-compose build $BUILD_ENV
    ## echo ""
  fi
}

docker_up() {
  daemon_mode
  echo ""
  echo "--------------------------------------------------------------------------"
  get_time
  echo "\033[22;34m[ $DATE ] ##### Docker Compose Up: \033[0m                     "
  echo "\033[22;32m[ $DATE ]       docker-compose up $RECREATE$BUILD_ENV \033[0m\n  "
  get_time
  echo "--------------------------------------------------------------------------"
  echo "\033[22;32m[ $DATE ]       docker-compose up $RECREATE$BUILD_ENV \033[0m "
  echo "--------------------------------------------------------------------------"
  docker-compose up $DAEMON $RECREATE$BUILD_ENV
  echo ""
}

main() {
  header
  cache
  recreate
  build_env
  docker_build
  docker_up
  footer
}

### START HERE ###
main $@
