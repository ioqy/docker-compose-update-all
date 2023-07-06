# A bash script to update all running docker compose containers to their newest available image

Executes `docker pull` and `docker compose up -d` for all running docker-compose files.

## Usage

To manually update your docker-compose containers call `docker-compose-update-all.sh` from the terminal.

To automatically update add the following command as a cron job:
```bash
/usr/local/bin/docker-compose-update-all.sh > /dev/null 2>&1
```

## Installation

```bash
sudo curl https://raw.githubusercontent.com/ioqy/docker-compose-update-all/master/docker-compose-update-all.sh -o /usr/local/bin/docker-compose-update-all.sh
sudo chmod a+rx /usr/local/bin/docker-compose-update-all.sh
```

## Exclude a docker-compose file from update

To exclude a `docker-compose.yml` file from the automatic update add a file with the name `.dockerupdateignore` to the directory.
