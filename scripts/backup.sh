#!/bin/ash

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

  *)
    echo "invalid database type provided"
    exit 1
    ;;
    
esac

if [[ $? != 0 ]]; then
  echo "could not export database"
  exit 1
fi

echo "uploading file"

rclone copy "${BACKUP_FILE}" "${RCLONE_REMOTE}:${BACKUP_FOLDER}"
if [[ $? != 0 ]]; then
  echo "rclone copy failed"
  exit 1
fi

echo "cleaning up"

rm -f "${BACKUP_FILE}"

if [[ -n "${HEALTH_CHECK_URL}" ]]; then
  echo "making health request"
  curl --request GET "${HEALTH_CHECK_URL}" \
    --silent \
    --output /dev/null \
    --max-time 15
fi

echo "done"
