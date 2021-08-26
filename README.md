# drive-mysql-backup

Backup your mysql database container to google drive.

## info

the script is run every day at 00:00.

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

## environment variables

| Variable            | Description |
| ------------------- | ----------- |
| DRIVE_CLIENT_ID     | google api client id `xxx.apps.googleusercontent.com` |
| DRIVE_CLIENT_SECRET | google api client secret |
| DRIVE_REFRESH_TOKEN | google api refresh token |
| DRIVE_FOLDER_ID     | the id of the google drive folder to upload the files to |
| DB_CONTAINER        | the name of the database container to backup |
| DB_USER             | the database user that will export the database |
| DB_PASSWORD         | the password of the database user |
