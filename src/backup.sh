#!/bin/sh

BACKUP_FILE="$(date +%Y-%m-%d_%H-%M-%S).sql"

echo "exporting database"

case "${DB_CONNECTION}" in

  mysql)
    mysqldump --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USERNAME}" --password="${DB_PASSWORD}" "${DB_DATABASE}" > "${BACKUP_FILE}"
    ;;

  postgres)
    export PGPASSWORD="${DB_PASSWORD}"
    pg_dump --host="${DB_HOST}" --port="${DB_PORT}" --dbname="${DB_DATABASE}" --username="${DB_USERNAME}" --no-password > "${BACKUP_FILE}"
    ;;

  sqlite)
    BACKUP_FILE="$(date +%Y-%m-%d_%H-%M-%S).sqlite"
    sqlite3 "/database/${DB_FILE}" ".backup '${BACKUP_FILE}'"
    ;;

  *)
    echo "invalid database type provided"
    exit 1
    ;;

esac

if [ "$?" != 0 ]; then
  echo "could not export database"
  exit 1
fi

echo "uploading file"

rclone copy "${BACKUP_FILE}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"
if [ "$?" != 0 ]; then
  echo "rclone copy failed"
  exit 1
fi

echo "deleting local backup file"

rm -f "${BACKUP_FILE}"

echo "deleting any old backups"

rclone delete --min-age "${BACKUP_AGE}"d --include "*.{sql,sqlite}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"

echo "done"
echo "==================================="
