#!/bin/bash

# Initializes Nginx and the git cgi scripts
# for git http-backend through fcgiwrap.
#
# Usage:
#   entrypoint <commands>
#
# Commands:
#   -start    starts the git server (nginx + fcgi)
#
#   -init     into bare repositories at `/var/lib/git`
#

set -o errexit

readonly GIT_PROJECT_ROOT="/var/lib/git"
readonly GIT_HTTP_EXPORT_ALL="true"
readonly GIT_USER="git"
readonly GIT_GROUP="git"

readonly FCGIPROGRAM="/usr/bin/fcgiwrap"
readonly USERID="nginx"
readonly FCGISOCKET="/var/run/fcgiwrap.socket"

main() {
  initialize_services
}

initialize_services() {
  sudo /usr/bin/spawn-fcgi \
    -s $FCGISOCKET \
    -F 4 \
    -u $USERID \
    -g $USERID \
    -U $USERID \
    -G $GIT_GROUP -- \
    "$FCGIPROGRAM"

  exec nginx
}

main "$@"
