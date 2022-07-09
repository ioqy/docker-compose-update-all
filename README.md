# A bash script to update all running docker compose containers to their newest available image

Executes `docker pull` and `docker up -d` for all running docker-compose files.

## Usage

To manually update your docker-compose containers call `docker-compose-update-all.sh` from the terminal.

To automatically update add the following command as a cron job:
```bash
/usr/local/bin/docker-compose-update-all.sh > /dev/null 2>&1
```

The script does not prune the old images.

To prune unused images after an update either run
```
docker image prune --force
```
or add the following command as a seperate cron job:
```
docker image prune --force > /dev/null 2>&1
```

## Installation

```bash
sudo curl https://raw.githubusercontent.com/ioqy/docker-compose-update-all/master/docker-compose-update-all.sh -o /usr/local/bin/docker-compose-update-all.sh
sudo chmod a+rx /usr/local/bin/docker-compose-update-all.sh
```
