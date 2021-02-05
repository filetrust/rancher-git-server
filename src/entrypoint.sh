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
  override_registry_url
  initialize_services
}

override_registry_url() {
  container_registry=$(</etc/container_registry)

  git clone /var/lib/git/icap-infrastructure.git icap-infra
  cd ./icap-infra
  git config --global user.email "rancher@glasswall.invalid"
  git config --global user.name "Rancher Server"
  git checkout add-image-registry
  /var/lib/git/update-docker-registry.sh container_registry
  git add .
  git commit -m 'Update the container registry url'
  git push --force

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
