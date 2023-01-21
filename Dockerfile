FROM alpine:edge

RUN apk --no-cache add \
    curl \
    postgresql-client \
    sqlite \
    tzdata

WORKDIR /app
COPY . /app

COPY --from=rclone/rclone:latest /usr/local/bin/rclone /usr/bin/rclone
COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

RUN ["chmod", "+x", "scripts/backup.sh", "scripts/entrypoint.sh"]

VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["scripts/entrypoint.sh"]
