FROM alpine:edge

# install required packages
RUN apk --no-cache add \
    postgresql-client \
    sqlite \
    tzdata

# create the app directory
WORKDIR /app

# copy project folder
COPY . ./

# copy rclone binary
COPY --from=rclone/rclone:latest /usr/local/bin/rclone /usr/bin/rclone

# copy mysqldump binary
COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

# volume for rclone config
VOLUME ["/root/.config/rclone"]

# entrypoint
ENTRYPOINT ["/app/src/entrypoint.sh"]

# cmd
CMD ["crond", "-l", "2", "-f"]
