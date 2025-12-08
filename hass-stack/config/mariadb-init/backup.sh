#!/bin/bash
DATE=$(date +%Y%m%d%H%M)
mariadb-dump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases --single-transaction | gzip --rsyncable >/backup/${DATE}_full_backup.sql.gz

# To restore the backup, use the following command:
# gunzip -c <PATH_TO_BACKUP>.sql.gz | mariadb -u root -p ${MYSQL_ROOT_PASSWORD}

# Delete old backup files, keeping the latest 15
find /backup -name '*full_backup.sql.gz' -type f -printf '%T@ %p\0' | sort -zrn | tail -z -n +16 | cut -z -d' ' -f2- | xargs -0 -r rm -f
