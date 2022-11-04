FROM alpine:edge

RUN apk --no-cache add curl postgresql-client tzdata

WORKDIR /app
COPY . /app

COPY --from=rclone/rclone:latest /usr/local/bin/rclone /usr/bin/rclone
COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump
COPY --from=postgres:alpine /usr/local/bin/pg_dump /usr/bin/pg_dump

RUN ["chmod", "+x", "scripts/backup.sh", "scripts/entrypoint.sh"]

VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
