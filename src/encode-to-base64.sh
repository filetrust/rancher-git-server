#!/usr/bin/env bash

# encodes the first argument to base64 and prints to the console
printf "%s" "$1" | base64 >> "$2"
