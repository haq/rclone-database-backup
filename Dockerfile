FROM alpine:3.15

# install required packages
RUN apk add --no-cache curl tzdata docker-cli rclone

# create the app directory
WORKDIR /app

# copy the source
COPY . /app

# give the scripts executable permissions
RUN ["chmod", "+x", "backup.sh"]
RUN ["chmod", "+x", "entrypoint.sh"]

# define volume for rclone config
VOLUME ["/root/.config/rclone"]

ENTRYPOINT ["/app/entrypoint.sh"]
