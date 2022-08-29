FROM alpine:edge

RUN apk --no-cache add \
    curl \
    rclone \
    postgresql-client \
    tzdata

WORKDIR /app
COPY . /app

COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

RUN ["chmod", "+x", "scripts/backup.sh"]
RUN ["chmod", "+x", "scripts/entrypoint.sh"]

VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
