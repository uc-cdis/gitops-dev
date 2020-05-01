#!/bin/bash

folder="$(dirname "$(realpath "$0")")"
command=(rsync -avz --exclude '*/data-volume/*' "${folder}/" reuben@cdistest.csoc:cdis-manifest/reuben.planx-pla.net/)
echo "${command[@]}"
${command[@]}
