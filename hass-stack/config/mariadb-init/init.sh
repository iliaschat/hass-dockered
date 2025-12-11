#!/bin/bash

# Initialize MariaDB with user and database
for _ in {1..30}; do
	if /usr/bin/mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; FLUSH PRIVILEGES;"; then
		break
	fi
	sleep 1
done

# Install cron if not present
if ! command -v cron >/dev/null 2>&1; then
	apt-get update && apt-get install -y cron
fi

# Make backup script executable
chmod +x /docker-entrypoint-initdb.d/backup.sh

# Create a crontab file for root user# Load the crontab for root user
crontab -u root /docker-entrypoint-initdb.d/crontab
# Start cron in the background using command specified in docker-compose.yml
# (command: cron)
# else enable the following lines to start cron here (but this runs only on container start)
cron
