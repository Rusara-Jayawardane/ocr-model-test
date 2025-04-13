#!/bin/bash
set -euo pipefail

services=("api-gateway" "model-server")
image_registry="roodocker7298"
git_sha="$(git rev-parse --short HEAD)"

cd "$(dirname "$0")/../.."

docker_build_and_push() {
  image_tag="${image_registry}/$1:${git_sha}"
  echo "building docker image for $service ..."
  docker build . -t "${image_tag}" -f Infrastructure/docker/"$1/Dockerfile"

  echo "pushing ${image_tag} to registry ..."
  docker push "${image_tag}"
}

docker_tests() {
  echo "running docker tests ..."
  docker-compose -f Infrastructure/docker/docker-compose.yaml up -d
  sleep 20
  # we can run tests here such as checking the response of health endpoints
  docker-compose -f Infrastructure/docker/docker-compose.yaml down
}

for service in "${services[@]}"
do
  docker_build_and_push "${service}"
  docker_tests
done
