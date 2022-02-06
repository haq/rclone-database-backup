FROM alpine:3.15

RUN apk add --no-cache curl postgresql-client rclone tzdata

WORKDIR /app
COPY . /app

COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

RUN ["chmod", "+x", "scripts/backup.sh"]
RUN ["chmod", "+x", "scripts/entrypoint.sh"]

VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
