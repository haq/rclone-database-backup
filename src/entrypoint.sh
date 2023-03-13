#!/bin/sh

check_env() {
  if [ -z "$1" ]; then
    echo "environment variable is missing a value"
    exit 1
  fi
}

check_file() {
  if [ ! -f "$1" ]; then
    echo "sqlite database not found"
    exit 1
  fi
}

# rclone command
if [ "$1" = "rclone" ]; then
  $*
  exit 0
fi

# check if all environment variables are set
check_env "${TZ}"
check_env "${CRON}"
check_env "${RCLONE_REMOTE}"
check_env "${BACKUP_FOLDER}"
check_env "${BACKUP_AGE}"
check_env "${DB_CONNECTION}"
if [ "${DB_CONNECTION}" = "sqlite" ]; then
  check_env "${DB_FILE}"
  check_file "/database/${DB_FILE}"
else
  check_env "${DB_HOST}"
  check_env "${DB_PORT}"
  check_env "${DB_DATABASE}"
  check_env "${DB_USERNAME}"
  check_env "${DB_PASSWORD}"
fi

# check if rclone config exists
rclone config show "${RCLONE_REMOTE}" > /dev/null
if [ "$?" != 0 ]; then
  echo "rclone config does not exist"
  exit 1
else
  echo "rclone config exists"
fi

# check if rclone config is functional
rclone mkdir "${RCLONE_REMOTE}:${BACKUP_FOLDER}" > /dev/null
if [ "$?" != 0 ]; then
  echo "rclone config is incorrect"
  exit 1
else
  echo "rclone config is correct"
fi

# configure crontab
crontab -l | grep -q "backup.sh" && echo "cron entry exists" || echo "${CRON} cd /app/src && sh backup.sh > /dev/stdout" | crontab - && echo "created cron entry"

#
echo "starting crond"
exec "$@"
