FROM alpine:3.14

# update index of available packages
RUN apk update

# install (curl & jq & tzdata & docker-cli)
RUN apk add --no-cache curl jq tzdata docker-cli

# create the app directory
WORKDIR /app

# copy the source
COPY . /app

# give the upload script execuatable permissions
RUN chmod +x backup.sh

# schedule the cron job
RUN echo "0 0 * * * cd /app && ./backup.sh" | crontab -
CMD ["crond", "-f"]
