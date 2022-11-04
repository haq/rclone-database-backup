# rclone-database-backup

Use Rclone to backup your MySQL or PostgreSQL database to any remote supported by Rclone.

## rclone

### create volume
```shell
docker volume create rclone_database_backup
```

### configure rclone remote
```shell
docker run --rm -it \
  -v rclone_database_backup:/root/.config/rclone \
  ghcr.io/haq/rclone-database-backup \
  rclone config
```

## container

### docker cli

```shell
docker run -d \
  --name=rclone-database-backup \
  --restart unless-stopped \
  -e TZ=America/Toronto \
  -e CRON=0 0 * * * \
  -e RCLONE_REMOTE=rclone_remote \
  -e BACKUP_FOLDER=database_backups \
  -e BACKUP_AGE=30 \
  -e HEALTH_CHECK_URL=cron_monitoring_service \ `#optional`
  -e DB_CONNECTION=mysql_or_postgres \
  -e DB_HOST=db_container \
  -e DB_PORT=db_port \
  -e DB_DATABASE=db_name \
  -e DB_USERNAME=db_user \
  -e DB_PASSWORD=db_password \
  -v rclone_database_backup:/root/.config/rclone \
  ghcr.io/haq/rclone-database-backup
```

### docker-compose

#### container
```yaml
backup:
  image: ghcr.io/haq/rclone-database-backup
  environment:
    - TZ=America/Toronto
    - CRON=0 0 * * *
    - RCLONE_REMOTE=rclone_remote
    - BACKUP_FOLDER=database_backups
    - BACKUP_AGE=30
    - HEALTH_CHECK_URL=cron_monitoring_service # optional
    - DB_CONNECTION=mysql_or_postgres 
    - DB_HOST=db_container
    - DB_PORT=db_port
    - DB_DATABASE=db_name
    - DB_USERNAME=db_user
    - DB_PASSWORD=db_password
  volumes:
    - rclone_database_backup:/root/.config/rclone
restart: unless-stopped
```

#### volume
```yaml
volumes:
  rclone_database_backup:
    external: true
```
