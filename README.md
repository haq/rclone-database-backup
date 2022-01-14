# rclone-mysql-backup

Backup your mysql database container.

## docker-cli

### create rclone config

```shell
docker volume create rclone-mysql-backup
docker run \
  --rm \
  -it \
  -v rclone-mysql-backup:/root/.config/rclone \
  ghcr.io/haq/rclone-mysql-backup \
  rclone config
```

### create container

```shell
docker run -d \
  --name=rclone-mysql-backup \
  -e TZ=America/Toronto \
  -e CRON="0 0 * * *" \
  -e RCLONE_REMOTE=rclone_remote \
  -e BACKUP_FOLDER=database_backups \
  -e HEALTH_CHECK_URL=cron_monitoring_service \
  -e DB_CONTAINER=db_container \
  -e DB_USER=db_user \
  -e DB_PASSWORD=db_password \
  -v rclone-mysql-backup:/root/.config/rclone \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  ghcr.io/haq/rclone-mysql-backup
```

## environment variables

| Variable         | Description                                     |
|------------------|-------------------------------------------------|
| TZ               | the timezone of the container                   |
| CRON             |                                                 |
| RCLONE_REMOTE    | the name of the remote used in rclone config    |
| BACKUP_FOLDER    | the name of the folder to upload the files to   |
| HEALTH_CHECK_URL | the endpoint of the cron monitoring service     |
| DB_CONTAINER     | the name of the database container to backup    |
| DB_USER          | the database user that will export the database |
| DB_PASSWORD      | the password of that database user              |
