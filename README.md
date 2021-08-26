# docker-mysql-backup
Backup your mysql database container to a s3 bucket.

## docker-cli
```bash
docker run -d \
  --name=docker-mysql-backup \
  -e S3_ENDPOINT=s3_endpoint \
  -e S3_REGION=s3_region \
  -e S3_BUCKET=s3_bucket \
  -e S3_KEY=s3_key \
  -e S3_SECRET=s3_secret \
  -e DB_CONTAINER=db_container \
  -e DB_USER=db_user \
  -e DB_PASSWORD=db_password \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  ghcr.io/haq/docker-mysql-backup
```