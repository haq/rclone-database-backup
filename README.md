# rclone-mysql-backup

Backup your mysql database container.

## docker-cli

### create rclone config

```shell
docker volume create rclone_mysql_backup
docker run --rm -it \
  -v rclone_mysql_backup:/root/.config/rclone \
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
  -e DATABASE=db_name \
  -e DB_TYPE=<mysql or postgres> \
  -e DB_HOST=db_container \
  -e DB_PORT=db_container \
  -e DB_USER=db_user \
  -e DB_PASSWORD=db_password \
  -v rclone_mysql_backup:/root/.config/rclone \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  ghcr.io/haq/rclone-mysql-backup
```
