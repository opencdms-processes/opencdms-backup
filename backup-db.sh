#!/bin/bash

# USAGE: ./backup-db.sh DB_HOST DB_PORT DB_USER DB_PASS OUTPUT_DIR
# This script generates a backup file named OUTPUT_DIR/ALL_DB_BACKUP_DOW.sql
# Where DOW could be replaced by SUN, MON, TUE, WED, THU, FRI, SAT
# You could schedule this at midnight and you will have backup of
# all databases on a host with all data, for last seven days.

if (($# < 5)) || (($# > 5))
then
  echo "5 arguments required."
  echo "Usage: ./backup-db.sh DB_HOST DB_PORT DB_USER DB_PASS OUTPUT_DIR"
  echo "Example: ./backup-db.sh localhost 5432 postgres password /path/to/output/dir"
  exit 1
fi

DOW=$(date +%a)

DB_HOST=$1
DB_PORT=$2
DB_USER=$3
DB_PASS=$4
OUTPUT_DIR=$5

BACKUP_FILE="${OUTPUT_DIR}/ALL_DB_BACKUP_${DOW^^}.sql"

export PGPASSWORD=$DB_PASS

pg_dumpall --host "$DB_HOST" --port "$DB_PORT" --username "$DB_USER" --no-privileges --file "$BACKUP_FILE"
