#!/bin/bash

# USAGE: ./backup-db.sh DB_HOST DB_PORT DB_USER DB_PASS DB_NAME OUTPUT_DIR
# This script generates a backup file named OUTPUT_DIR/ALL_DB_BACKUP_DOW.sql
# Where DOW could be replaced by SUN, MON, TUE, WED, THU, FRI, SAT
# You could schedule this at midnight and you will have backup of
# the database name you passed on a host with all data, for last seven days.

if (($# < 6)) || (($# > 6))
then
  echo "6 arguments required."
  echo "Usage: ./backup-db.sh DB_HOST DB_PORT DB_USER DB_PASS DB_NAME OUTPUT_DIR"
  echo "Example: ./backup-db.sh localhost 5432 postgres password postgres /path/to/output/dir"
  exit 1
fi

DOW=$(date +%a)

DB_HOST=$1
DB_PORT=$2
DB_USER=$3
DB_PASS=$4
DB_NAME=$5
OUTPUT_DIR=$6

BACKUP_FILE="${OUTPUT_DIR}/ALL_DB_BACKUP_${DOW^^}.sql"

export PGPASSWORD=$DB_PASS

pg_dump --host "$DB_HOST" --port "$DB_PORT" --username "$DB_USER" --dbname "$DB_NAME" --no-privileges --file "$BACKUP_FILE"
