#!/bin/bash

# lock script to prevent parallel execution
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

# iterate through running docker compose files
docker compose ls | tail -n+2 | while read name status configfile; do

  # skip non existing files
  [ -f "$configfile" ] || continue

  projectdirectory="$(dirname $configfile)"

  # pull images and restart containers
  docker compose --project-directory "$projectdirectory" pull \
    && docker compose --project-directory "$projectdirectory" up --detach --remove-orphans

done
