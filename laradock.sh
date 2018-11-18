#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  DOCKER BUILDER SCRIPT
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  Repository : https://github.com/zeroc0d3/docker-framework
#  License    : MIT
# -----------------------------------------------------------------------------

TITLE="LARADOCK BUILDER SCRIPT"      # script name
VER="1.4.4"                          # script version
ENV="0"                              # container environment (0 = development, 1 = production)
SKIP_BUILD="0"                       # (0 = with build process, 1 = bypass build process)
REMOVE_CACHE="0"                     # (0 = using cache, 1 = no-cache)
RECREATE_CONTAINER="0"               # (0 = disable recreate container, 1 = force recreate container)
DAEMON_MODE="1"                      # (0 = disable daemon mode, 1 = running daemon mode / background)

USERNAME=`echo $USER`
PATH_HOME=`echo $HOME`

##  LIST CONTAINER NAME & PORTS
## +==========+============+==================================+
## |   INITIALIZE PORTS    |                                  |
## +-----------------------+         CONTAINER NAME           |
## |   CUST*  |   EXPOSE   |                                  |
## +==========+============+==================================+
## |   8100   |     8080   |  adminer                         |
## +----------+------------+----------------------------------+
## |   8101   |     3000   |  aerospike - service             |
## |   8102   |     3001   |  aerospike - fabric              |
## |   8103   |     3002   |  aerospike - heartbeat           |
## |   8104   |     3003   |  aerospike - info                |
## +----------+------------+----------------------------------+
## |   8105   |       80   |  apache2 (http)                  |
## |   8106   |      443   |  apache2 (https)                 |
## +----------+------------+----------------------------------+
## |   8107   |       22   |  aws                             |
## +----------+------------+----------------------------------+
## |   8108   |    11300   |  beanstalkd                      |
## |   8109   |     2080   |  beanstalkd-console              |
## +----------+------------+----------------------------------+
## |   8110   |       80   |  caddy (http)                    |
## |   8111   |      443   |  caddy (https)                   |
## |   8112   |     2015   |  caddy                           |
## +----------+------------+----------------------------------+
## |   8113   |       22   |  certbot                         |
## +----------+------------+----------------------------------+
## |   8114   |     4200   |  cratedb (http)                  |
## |   8115   |     4200   |  cratedb (http)                  |
## |   8116   |     4300   |  cratedb (transport)             |
## |   8117   |     5432   |  cratedb (postgres)              |
## +----------+------------+----------------------------------+
## |   8118   |     9200   |  elasticsearch                   |
## |   8119   |     9300   |                                  |
## +----------+------------+----------------------------------+
## |   8120   |     3000   |  grafana                         |
## +----------+------------+----------------------------------+
## |   8121   |       80   |  haproxy                         |
## +----------+------------+----------------------------------+
## |   8122   |     9000   |  hhvm                            |
## +----------+------------+----------------------------------+
## |   8123   |     8080   |  jenkins (web)                   |
## |   8124   |    50000   |  jenkins (slave agent)           |
## +----------+------------+----------------------------------+
## |   8125   |     5601   |  kibana                          |
## +----------+------------+----------------------------------+
## |   8126   |     3000   |  laravel-echo-server             |
## +----------+------------+----------------------------------+
## |   8127   |       80   |  maildev (http)                  |
## |   8128   |       25   |  maildev (ssh)                   |
## +----------+------------+----------------------------------+
## |   8129   |     1025   |  mailhog                         |
## |   8130   |     8025   |                                  |
## +----------+------------+----------------------------------+
## |   8131   |     3306   |  mariadb                         |
## |   8132   |     3306   |  mysql                           |
## |   8133   |     3306   |  percona                         |
## +----------+------------+----------------------------------+
## |   8134   |    11211   |  memcached                       |
## +----------+------------+----------------------------------+
## |   8135   |       22   |  minio                           |
## +----------+------------+----------------------------------+
## |   8136   |    27017   |  mongodb                         |
## +----------+------------+----------------------------------+
## |   8137   |     1433   |  mssql                           |
## +----------+------------+----------------------------------+
## |   8138   |     7474   |  neo4j                           |
## |   8139   |     1337   |                                  |
## +----------+------------+----------------------------------+
## |   8140   |       80   |  nginx                           |
## +----------+------------+----------------------------------+
## |   8141   |       80   |  pgadmin                         |
## +----------+------------+----------------------------------+
## |   8142   |       80   |  phpfpm (only) - workspace       |
## |   8143   |     9090   |  phpfpm (only) - xdebug          |
## +----------+------------+----------------------------------+
## |   8144   |       80   |  phpmyadmin                      |
## +----------+------------+----------------------------------+
## |   8145   |     9000   |  portainer                       |
## +----------+------------+----------------------------------+
## |   8146   |     5432   |  postgresql                      |
## |   8147   |     5432   |  postgresql-postgis              |
## +----------+------------+----------------------------------+
## |   8148   |       22   |  python                          |
## |   8149   |       22   |  python3                         |
## +----------+------------+----------------------------------+
## |   8150   |    15671   |  rabbitmq                        |
## |   8151   |    15672   |                                  |
## +----------+------------+----------------------------------+
## |   8152   |     6379   |  redis                           |
## +----------+------------+----------------------------------+
## |   8153   |     8080   |  rethinkdb                       |
## +----------+------------+----------------------------------+
## |   8154   |       22   |  ruby                            |
## |   8155   |     3000   |  rails (ruby on rails)           |
## |   8156   |     9000   |  rails + webpack                 |
## +----------+------------+----------------------------------+
## |   8157   |     4444   |  selenium                        |
## +----------+------------+----------------------------------+
## |   8158   |     9983   |  solr                            |
## +----------+------------+----------------------------------+
## |   8159   |     8080   |  swagger-ui                      |
## |   8160   |     8092   |  swagger-data                    |
## +----------+------------+----------------------------------+
## |   8161   |     8080   |  spark (master)                  |
## |   8162   |     8881   |  spark (worker)                  |
## +----------+------------+----------------------------------+
## |   8163   |       22   |  terraform                       |
## +----------+------------+----------------------------------+
## |   8164   |     8080   |  varnish                         |
## +----------+------------+----------------------------------+
## |   8165   |       22   |  vim                             |
## +----------+------------+----------------------------------+
## |   8200   |     9000   |  domikado-phpfpm                 |
## |   8201   |       22   |  domikado-php-worker             |
## |   8202   |       22   |  domikado-workspace              |
## +----------+------------+----------------------------------+
## |   8300   |     9093   |  alertmanager                    |
## |   8301   |     3000   |  caddy grafana                   |
## |   8302   |     9090   |  caddy prometheus                |
## |   8303   |     9091   |  caddy pushgateway               |
## |   8304   |     9093   |  caddy alertmanager              |
## |   8305   |     3000   |  cadvisor                        |
## |   8306   |     9100   |  nodeexporter                    |
## |   8307   |     9090   |  prometheus                      |
## |   8308   |     9091   |  pushgateway                     |
## +----------+------------+----------------------------------+
## |   8400   |     3000   |  ansible                         |
## +----------+------------+----------------------------------+
## |   8401   |     8080   |  jenkins master (web ui)         |
## |   8402   |    50000   |  jenkins slave                   |
## +----------+------------+----------------------------------+
## |   8501   |     8089   |  locust master & slave           |
## |   8502   |     5557   |  locust master                   |
## |   8503   |     5558   |  locust master                   |
## |   8504   |    50671   |  locust slave                    |
## |   8505   |    50672   |  locust slave                    |
## +----------+------------+----------------------------------+
## |   8601   |       22   |  golang                          |
## +----------+------------+----------------------------------+
## |   9901   |       80   |  workspace (phpfpm)              |
## |   9902   |     9090   |  workspace (xdebug)              |
## +----------+------------+----------------------------------+
##  *) Customize port for Docker Framework
##  Required (must included)
##  - Container "consul"
##  - Container "grafana"
##  - Container "portainer"

CONTAINER_PRODUCTION="consul workspace grafana nginx adminer aerospike elasticsearch mariadb memcached mongodb mysql percona pgadmin phpfpm phpmyadmin portainer postgresql redis solr spark terraform ansible jenkins golang locust-master locust-slave"
CONTAINER_DEVELOPMENT="consul alertmanager caddy cadvisor grafana nodeexporter portainer prometheus pushgateway ansible jenkins golang"

export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300

get_time() {
  DATE=`date '+%Y-%m-%d %H:%M:%S'`
}

print_line0() {
  echo "\033[22;32m=======================================================================================\033[0m"
}

print_line1() {
  echo "\033[22;32m---------------------------------------------------------------------------------------\033[0m"
}

print_line2() {
  echo "---------------------------------------------------------------------------------------"
}

logo() {
  clear
  print_line0
  echo "\033[22;31m '##::::::::::'###::::'########:::::'###::::'########:::'#######:::'######::'##:::'##: \033[0m"
  echo "\033[22;31m  ##:::::::::'## ##::: ##.... ##:::'## ##::: ##.... ##:'##.... ##:'##... ##: ##::'##:: \033[0m"
  echo "\033[22;31m  ##::::::::'##:. ##:: ##:::: ##::'##:. ##:: ##:::: ##: ##:::: ##: ##:::..:: ##:'##::: \033[0m"
  echo "\033[22;31m  ##:::::::'##:::. ##: ########::'##:::. ##: ##:::: ##: ##:::: ##: ##::::::: #####:::: \033[0m"
  echo "\033[22;31m  ##::::::: #########: ##.. ##::: #########: ##:::: ##: ##:::: ##: ##::::::: ##. ##::: \033[0m"
  echo "\033[22;31m  ##::::::: ##.... ##: ##::. ##:: ##.... ##: ##:::: ##: ##:::: ##: ##::: ##: ##:. ##:: \033[0m"
  echo "\033[22;31m  ########: ##:::: ##: ##:::. ##: ##:::: ##: ########::. #######::. ######:: ##::. ##: \033[0m"
  echo "\033[22;31m ........::..:::::..::..:::::..::..:::::..::........::::.......::::......:::..::::..:: \033[0m"
  print_line1
  echo "\033[22;32m# $TITLE :: ver-$VER                                                                   \033[0m"
}

header() {
  logo
  print_line0
  get_time
  echo "\033[22;31m# BEGIN PROCESS..... (Please Wait)  \033[0m"
  echo "\033[22;31m# Start at: $DATE  \033[0m\n"
}

footer() {
  print_line0
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
    print_line2
    get_time
    echo "\033[22;34m[ $DATE ] ##### Docker Compose: \033[0m                        "
    echo "\033[22;32m[ $DATE ]       docker-compose build $CACHE$BUILD_ENV \033[0m\n"

    ## MULTI CONTAINER
    ## ------------------------------
    for CONTAINER in $BUILD_ENV
    do
      get_time
      print_line2
      echo "\033[22;32m[ $DATE ]       docker-compose build $CONTAINER \033[0m        "
      print_line2
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
  print_line2
  get_time
  echo "\033[22;34m[ $DATE ] ##### Docker Compose Up: \033[0m                     "
  echo "\033[22;32m[ $DATE ]       docker-compose up $RECREATE$BUILD_ENV \033[0m\n  "
  get_time
  print_line2
  echo "\033[22;32m[ $DATE ]       docker-compose up $RECREATE$BUILD_ENV \033[0m "
  print_line2
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
