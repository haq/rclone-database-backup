#!/bin/ash

# get all the databases names
DATABASES=$(
  docker exec "${DB_CONTAINER}" /usr/bin/mysql -u "${DB_USER}" --password="${DB_PASSWORD}" -Bse "show databases" |
    grep -Ev "information_schema|performance_schema|mysql|phpmyadmin"
)
if [[ $? != 0 ]]; then
  echo "could not fetch all databases names"
  exit 1
fi

# loop through each database to export
for DATABASE in ${DATABASES}; do

  # clean the database name
  DATABASE=$(echo "${DATABASE}" | tr -d "\r\n")

  # export the database
  docker exec "${DB_CONTAINER}" /usr/bin/mysqldump -u "${DB_USER}" --password="${DB_PASSWORD}" "${DATABASE}" > "${DATABASE}".sql
  if [[ $? != 0 ]]; then
    echo "could not export ${DATABASE}"
    exit 1
  fi

done

echo "creating archive"

# create a gzipped tarball out of all exported .sql files
BACKUP_FILE="$(date +%Y-%m-%d).tar.gz"
tar -czf BACKUP_FILE *.sql

echo "uploading file"

# copy the backup file using rclone
rclone copy "${BACKUP_FILE}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"
if [[ $? != 0 ]]; then
  echo "rclone copy failed"
  exit 1
fi

echo "cleaning up"

# remove all the .sql file dumps
find . -name "*.sql" -type f -delete

# remove the backup file
rm -f backup.tar.gz

# make get request to health url
if [[ -v "${HEALTH_CHECK_URL}" ]]; then
  curl --request GET ${HEALTH_CHECK_URL} \
    --silent \
    --output /dev/null \
    --max-time 15
fi

echo "done"
