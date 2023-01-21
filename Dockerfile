FROM alpine:edge

# install required packages
RUN apk --no-cache add \
    curl \
    postgresql-client \
    rclone \
    sqlite \
    tzdata

# create the app directory
WORKDIR /app

# copy project folder
COPY . ./

# copy mysqldump binary
COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

# fix permissions
RUN ["chmod", "+x", "scripts/backup.sh", "scripts/entrypoint.sh"]

# volume for rclone config
VOLUME ["/root/.config/rclone"]

# entrypoint
ENTRYPOINT ["/bin/sh", "scripts/entrypoint.sh"]
