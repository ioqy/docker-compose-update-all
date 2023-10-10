#!/usr/bin/env bash

# lock script to prevent parallel execution
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

export LOG_LEVEL=error

docker image prune --all --force

# pull all images
for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v '<none>'); do
  docker pull $image --quiet
done

# Get list of all running containers
containerList=$(docker ps --quiet --all)

if [[ -n $containerList ]]; then

  # Get compose files of the containers
  configFileList=$(docker inspect $containerList --format '{{index .Config.Labels "com.docker.compose.project.config_files"}}' | sort | uniq)

  # Iterate through running docker compose files
  for configFile in $configFileList; do

    # skip non existing files
    [ -f "$configFile" ] || continue

    projectDirectory="$(dirname $configFile)"

    # skip ignored project directories
    [ -f "$projectDirectory/.dockerupdateignore" ] && continue

    # restart container
    docker compose --project-directory "$projectDirectory" up --detach --remove-orphans

  done

fi

docker image prune --all --force
