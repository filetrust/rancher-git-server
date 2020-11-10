#!/usr/bin/env bash

shopt -s dotglob

find * -prune -type d | while IFS= read -r d; do
    printf "\nCurrent directory is: $d\n\n"
    cd $d

    grep '<<.*>>' values.yaml | while read -r line; do
      echo $line
      currsecret=$(echo "$line" | sed 's/.*<<\(.*\)>>.*/\1/')
      echo $currsecret
      val=$(az keyvault secret show --id $currsecret|  jq -r '.value')
      echo $val
      cat values.yaml | sed "s~<<$currsecret>>~$val~g" > newvalues.yaml
      mv newvalues.yaml values.yaml
    done

    cd ..
done




