# rclone-database-backup

Use Rclone to back up your MySQL, PostgreSQL or SQLite database to any remote.

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

## docker-compose

### container
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
    - DB_CONNECTION=mysql_or_postgres_or_sqlite
    - DB_FILE=path_to_sqlite_database_file.sqlite # sqlite only
    - # mysql or postgres only
    - DB_HOST=db_container
    - DB_PORT=db_port
    - DB_DATABASE=db_name
    - DB_USERNAME=db_user
    - DB_PASSWORD=db_password
  volumes:
    - rclone_database_backup:/root/.config/rclone
    - sqlite_database:/database # sqlite only
  restart: unless-stopped
```

### volume
```yaml
volumes:
  rclone_database_backup:
    external: true
```
