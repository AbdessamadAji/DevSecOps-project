#!/bin/sh

set -eu
# cronjob will inject credentials

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="/tmp/postgres-${DATE}.sql"

echo "====================================="
echo "Starting PostgreSQL backup..."
echo "Time: $(date)"
echo "====================================="

export PGPASSWORD="$POSTGRES_PASSWORD"

echo "Creating SQL dump..."

pg_dump \
  -h "$POSTGRES_HOST" \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  > "$BACKUP_FILE"

echo "Configuring MinIO..."

export MC_CONFIG_DIR=/tmp/.mc

mc alias set minio \
  "$MINIO_ENDPOINT" \
  "$MINIO_ROOT_USER" \
  "$MINIO_ROOT_PASSWORD"

echo "Uploading backup to MinIO..."

mc cp "$BACKUP_FILE" minio/postgres-backups/

echo "Backup uploaded successfully."

echo "Cleaning temporary files..."

rm -f "$BACKUP_FILE"

echo "====================================="
echo "Backup completed successfully!"
echo "====================================="
