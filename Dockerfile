FROM alpine:3.16

RUN apk add --no-cache curl rclone postgresql-client tzdata

WORKDIR /app
COPY . /app

COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

RUN ["chmod", "+x", "scripts/backup.sh"]
RUN ["chmod", "+x", "scripts/entrypoint.sh"]

VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
