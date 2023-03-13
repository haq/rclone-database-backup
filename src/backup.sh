#!/bin/sh

BACKUP_FILE="$(date +%Y-%m-%d_%H-%M-%S).sql"

color "exporting database"

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
    color "invalid database type provided"
    exit 1
    ;;

esac

if [ "$?" != 0 ]; then
  color "could not export database"
  exit 1
fi

color "uploading file"

rclone copy "${BACKUP_FILE}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"
if [ "$?" != 0 ]; then
  color "rclone copy failed"
  exit 1
fi

color "deleting local backup file"

rm -f "${BACKUP_FILE}"

color "deleting any old backups"

rclone delete --min-age "${BACKUP_AGE}"d --include "*.{sql,sqlite}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"

color "done"
color "==================================="
