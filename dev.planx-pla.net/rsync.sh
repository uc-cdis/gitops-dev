#!/bin/bash

folder="$(dirname "$(realpath "$0")")"
command=(rsync -avz --exclude '*/data-volume/*' "${folder}/" devplanetv1@cdistest.csoc:cdis-manifest/dev.planx-pla.net/)
echo "${command[@]}"
${command[@]}
