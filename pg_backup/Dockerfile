FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update; apt -y --no-install-recommends install cron python3-pip vim postgresql-contrib \
    && apt -y --purge autoremove && apt clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install awscli

COPY pg_backup.sh /pg_backup.sh
RUN chmod +x /pg_backup.sh

RUN touch /var/log/cron.log
RUN (crontab -l ; echo "0 12 * * * /pg_backup.sh >> /var/log/cron.log") | crontab

CMD cron && tail -f /var/log/cron.log
