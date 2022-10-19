# rclone-database-backup

Backup your database container running in docker.

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
  -e HEALTH_CHECK_URL=cron_monitoring_service \
  -e DB_CONNECTION=<mysql or postgres> \
  -e DB_HOST=db_container \
  -e DB_PORT=db_port \
  -e DB_DATABASE=db_name \
  -e DB_USERNAME=db_user \
  -e DB_PASSWORD=db_password \
  -v rclone_database_backup:/root/.config/rclone \
  ghcr.io/haq/rclone-database-backup
```

### docker-compose
```yaml
  backup:
    image: ghcr.io/haq/rclone-database-backup
    environment:
      - TZ=America/Toronto
      - CRON=0 0 * * *
      - RCLONE_REMOTE=rclone_remote
      - BACKUP_FOLDER=database_backups
      - HEALTH_CHECK_URL=cron_monitoring_service
      - DB_CONNECTION=<mysql or postgres> 
      - DB_HOST=db_container
      - DB_PORT=db_port
      - DB_DATABASE=db_name
      - DB_USERNAME=db_user
      - DB_PASSWORD=db_password
    volumes:
      - rclone_database_backup:/root/.config/rclone
    restart: unless-stopped

volumes:
  rclone_database_backup:
    external: true
```
