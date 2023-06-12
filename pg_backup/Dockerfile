FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && apt-get install -y dirmngr ca-certificates software-properties-common gnupg gnupg2 apt-transport-https curl -y
RUN curl -fSsL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg > /dev/null
RUN echo deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main | tee -a /etc/apt/sources.list.d/postgresql.list
RUN apt-get -y update; apt-get -y --no-install-recommends install cron python3-pip vim postgresql-client-15 postgresql-15 \
    && apt-get -y --purge autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install awscli

COPY pg_backup.sh /pg_backup.sh
RUN chmod +x /pg_backup.sh

RUN touch /var/log/cron.log
RUN (crontab -l ; echo "0 12 * * * /pg_backup.sh >> /var/log/cron.log") | crontab

CMD cron && tail -f /var/log/cron.log
