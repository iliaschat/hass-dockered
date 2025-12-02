#!/bin/bash
# Initialize MariaDB with user and database
/usr/bin/mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; FLUSH PRIVILEGES;"

# Install cron if not present
apt-get update && apt-get install -y cron
# Add cron job to run backup.sh at 1am daily
echo "0 1 * * * /usr/local/bin/backup.sh" >> /etc/crontab
# Start cron in the background
cron
