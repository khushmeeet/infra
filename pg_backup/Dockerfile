FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG POSTGRES_HOST
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION
ENV POSTGRES_HOST $POSTGRES_HOST
ENV POSTGRES_USER $POSTGRES_USER
ENV POSTGRES_PASSWORD $POSTGRES_PASSWORD

RUN apt-get -y update; apt-get -y --no-install-recommends install cron python3-pip vim postgresql postgresql-contrib \
    && apt-get -y --purge autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install awscli

COPY pg_backup.sh /pg_backup.sh
COPY test.sh /test.sh
RUN chmod +x /pg_backup.sh
RUN chmod +x /test.sh

RUN echo "* * * * * /test.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron
RUN touch /var/log/cron.log
RUN crontab /etc/cron.d/backup-cron

CMD ["/bin/bash", "-c", "cron -f && tail -f /var/log/cron.log"]
