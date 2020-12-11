#!/bin/bash

folder="$(dirname "$(realpath "$0")")"
command=(rsync -avz --exclude '*/data-volume/*' "${folder}/" mjmartinson@cdistest.csoc:cdis-manifest/mjmartinson.planx-pla.net/)
echo "${command[@]}"
${command[@]}
