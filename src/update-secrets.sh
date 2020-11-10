#!/usr/bin/env bash

grep '<<.*>>' values.yaml | while read -r line; do
  echo $line
  currsecret=$(echo "$line" | sed 's/.*<<\(.*\)>>.*/\1/')
  echo $currsecret
  val=$(az keyvault secret show --id $currsecret|  jq -r '.value')
  echo $val
  cat values.yaml | sed "s~<<$currsecret>>~$val~g" > newvalues.yaml
  mv newvalues.yaml values.yaml
done