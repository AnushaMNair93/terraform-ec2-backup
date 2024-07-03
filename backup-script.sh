#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_DIR=~/backup
TARGET_DIR=/path/to/directory
S3_BUCKET="backup-bucket"
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_FILE -C $TARGET_DIR .
aws s3 cp $BACKUP_FILE s3://$S3_BUCKET/
