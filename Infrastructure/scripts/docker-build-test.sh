#!/bin/bash
set -euo pipefail

services=("api-gateway" "model-server")
image_registry="$1"
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
  sleep 10

  test_image_path=$(readlink -f docs/img/architecture-diagram.png)
  response_code="$(curl -X POST http://localhost:8001/gateway/ocr -o /dev/null -s -w "%{http_code}\n" -F "image_file=@$test_image_path" || true)"
  echo "$response_code"

  if [ "$response_code" -eq 200 ]; then
    echo "Success: Received 200 OK"
    echo "Tests passed !"
  else
    echo "Failure: Received $response_code"
    echo "Tests failed !"
    docker-compose -f Infrastructure/docker/docker-compose.yaml down
    exit 1
  fi
  # we can run tests here such as checking the response of health endpoints

  docker-compose -f Infrastructure/docker/docker-compose.yaml down
}

for service in "${services[@]}"
do
  docker_build_and_push "${service}"
done

docker_tests