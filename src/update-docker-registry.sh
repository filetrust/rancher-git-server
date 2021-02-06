#!/usr/bin/env bash

shopt -s dotglob
container_registry=${1:-gwicapcontainerregistry.azurecr.io}
echo REGISTRY is $container_registry

find * -prune -type d | while IFS= read -r d; do
    printf "\nCurrent directory is: $d\n\n"
    cd $d

    if [ -a values.yaml ]
      then
	      yq write values.yaml 'imagestore.(registry==*).registry' ${container_registry}/ -i
    fi

    cd ..
done
