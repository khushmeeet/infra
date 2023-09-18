#!/bin/bash

source ~/creds.sh
export PATH=/usr/local/bin:$PATH

current_year=$(date +%Y)
current_month=$(date +%m)
current_date=$(date +%d)

# Set backup directory and filename
BACKUP_DIR="${HOME}/backups"
BACKUP_FILENAME="pg_backup_${current_date}.sql"
S3_LOCATION="s3://infra-pg-backup/${current_year}/${current_month}/"

mkdir -p "$BACKUP_DIR"

# Create backup
PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -Fc > "$BACKUP_DIR/$BACKUP_FILENAME"

gzip "$BACKUP_DIR/$BACKUP_FILENAME"
echo "[$(date +'%Y-%m-%d %H:%M:%S')]Backup complete: $BACKUP_DIR/$BACKUP_FILENAME.gz"

aws s3 cp "$BACKUP_DIR/$BACKUP_FILENAME.gz" $S3_LOCATION
echo "[$(date +'%Y-%m-%d %H:%M:%S')]Copy to S3 complete: $BACKUP_DIR/$BACKUP_FILENAME.gz"

rm -rf $BACKUP_DIR/*
