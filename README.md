# drive-mysql-backup

Backup your mysql database container to google drive.

## docker-cli

```shell
docker run -d \
  --name=drive-mysql-backup \
  -e TZ=America/Toronto \
  -e DRIVE_CLIENT_ID=drive_client_id \
  -e DRIVE_CLIENT_SECRET=drive_client_secret \
  -e DRIVE_REFRESH_TOKEN=drive_refresh_token \
  -e DRIVE_FOLDER_ID=drive_folder_id \
  -e DB_CONTAINER=db_container \
  -e DB_USER=db_user \
  -e DB_PASSWORD=db_password \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  ghcr.io/haq/drive-mysql-backup
```