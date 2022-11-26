#!/bin/bash

# lock script to prevent parallel execution
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

export LOG_LEVEL=error

# pull all images
for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v '<none>');do
  docker pull $image --quiet
done

# iterate through running docker compose files
docker compose ls | tail -n+2 | while read name status configfile; do

  # skip non existing files
  [ -f "$configfile" ] || continue

  projectdirectory="$(dirname $configfile)"

  # skip ignored project directories
  [ -f "$projectdirectory/.dockerupdateignore" ] && continue

  # pull images and restart containers
  docker compose --project-directory "$projectdirectory" pull --quiet \
    && docker compose --project-directory "$projectdirectory" up --detach --remove-orphans --quiet-pull

done

docker image prune --force
