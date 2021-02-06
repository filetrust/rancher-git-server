#!/usr/bin/env bash

app_id=$(cat /run/secrets/az-secret | jq -r '.clientId')
password=$(cat /run/secrets/az-secret | jq -r '.clientSecret')
tenant_id=$(cat /run/secrets/az-secret | jq -r '.tenantId')

az login --service-principal --username $app_id --password $password --tenant $tenant_id

if [[ $? != 0 ]]; then
  echo "Azure login failed"
  exit 1
fi

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
