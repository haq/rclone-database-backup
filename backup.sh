#!/bin/ash

# get all the database names
DATABASES=$(
  docker exec -it "${DB_CONTAINER}" /usr/bin/mysql -u "${DB_USER}" --password="${DB_PASSWORD}" -Bse "show databases" |
    grep -Ev "information_schema|performance_schema|mysql|phpmyadmin"
)

# loop through each database to export
for DATABASE in ${DATABASES}; do

  # clean the database name
  DATABASE=$(echo "${DATABASE}" | tr -d "\r\n")

  echo "exporting ${DATABASE}"

  # export the database
  docker exec "${DB_CONTAINER}" /usr/bin/mysqldump -u "${DB_USER}" --password="${DB_PASSWORD}" "${DATABASE}" > "${DATABASE}".sql
done

echo "creating archive"

# create a gzipped tarball out of all exported .sql files
tar -czf backup.tar.gz *.sql

echo "requesting access token"

# get access token
ACCESS_TOKEN=$(
  curl --request POST \
    --silent \
    --data "client_id=${DRIVE_CLIENT_ID}&client_secret=${DRIVE_CLIENT_SECRET}&refresh_token=${DRIVE_REFRESH_TOKEN}&grant_type=refresh_token" \
    "https://accounts.google.com/o/oauth2/token" |
    jq ".access_token"
)

echo "uploading file"

# upload the backup file
curl --request POST \
  --silent \
  --output /dev/null \
  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
  --form "metadata={ \
    name: '$(date +%Y-%m-%d).tar.gz', \
    mimeType: 'application/gzip', \
    parents: ['${DRIVE_FOLDER_ID}'] \
  };type=application/json;charset=UTF-8" \
  --form "file=@backup.tar.gz;type=application/gzip" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart"

echo "cleaning up"

# remove all the .sql file dumps
find . -name "*.sql" -type f -delete

# remove the backup file
rm -f backup.tar.gz

echo "done"
