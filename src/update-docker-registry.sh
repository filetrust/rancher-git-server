#!/usr/bin/env bash

if [ "$1" = "" ]
then
  echo "Usage: $0 Enter a docker container registry, e.g gwicapcontainerregistry.azurecr.io/"
  exit
fi
echo "Container registry is $1"
shopt -s dotglob

find * -prune -type d | while IFS= read -r d; do
    printf "\nCurrent directory is: $d\n\n"
    cd $d

    if [ -a values.yaml ]
      then
	      yq write values.yaml 'imagestore.(registry==*).registry' $1 -i
    fi

    cd ..
done

