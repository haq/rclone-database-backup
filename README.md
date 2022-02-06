# rclone-database-backup

Backup your database container running in docker.

## docker-cli

### create rclone config

```shell
docker volume create rclone_database_backup
docker run --rm -it \
  -v rclone_database_backup:/root/.config/rclone \
  ghcr.io/haq/rclone-database-backup \
  rclone config
```

### create container

```shell
docker run -d \
  --name=rclone-mysql-backup \
  --restart unless-stopped \
  -e TZ=America/Toronto \
  -e CRON=0 0 * * * \
  -e RCLONE_REMOTE=rclone_remote \
  -e BACKUP_FOLDER=database_backups \
  -e HEALTH_CHECK_URL=cron_monitoring_service \
  -e DB_CONNECTION=<mysql or postgres> \
  -e DB_HOST=db_container \
  -e DB_PORT=db_container \
  -e DB_DATABASE=db_name \
  -e DB_USERNAME=db_user \
  -e DB_PASSWORD=db_password \
  -v rclone_database_backup:/root/.config/rclone \
  ghcr.io/haq/rclone-database-backup
```
