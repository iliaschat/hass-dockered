#!/bin/bash
mariadb-dump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases --single-transaction | gzip --rsyncable > /backup/full_backup.sql.gz
