# Home Assistant Docker Setup

This repository contains a Docker Compose configuration for running Home Assistant with a database and configuration editor.

## Services

- **Home Assistant**: Main smart home platform (port 8123). Note: Built-in backup integration is not available in Core; use external tools for backups.
- **MariaDB**: Database for Home Assistant.
- **HASS Configurator**: Web-based configuration editor (port 3218).

## Prerequisites

- Docker and Docker Compose installed.
- Update environment variables in `.env` file (e.g., MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, PUID, PGID, TZ).
- Make the MariaDB init script executable: `chmod +x ./config/mariadb-init/init.sh`.
- Define required environment variables in a `.env` file in the parent folder (`<hass-dockered>` - the root folder of this repository).

## Environment Variables

The following environment variables are required and should be defined in a `.env` file in the parent folder:

- **MYSQL_ROOT_PASSWORD**: Root password for MariaDB.
- **MYSQL_DATABASE**: Name of the Home Assistant database.
- **MYSQL_USER**: Username for Home Assistant database access.
- **MYSQL_PASSWORD**: Password for the Home Assistant database user.
- **PUID**: User ID for file permissions (e.g., 1000).
- **PGID**: Group ID for file permissions (e.g., 1000).
- **TZ**: Timezone (e.g., America/New_York).

Example `.env` file content:

```
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=homeassistant
MYSQL_USER=homeassistant
MYSQL_PASSWORD=your_password
PUID=1000
PGID=1000
TZ=America/New_York
```

## Usage

1. Clone or download this repository.
2. Edit `.env` with your specific values.
3. Run `docker-compose --env-file ../.env up -d` to start the services using the `.env` file from the parent folder.
4. Access Home Assistant at `http://localhost:8123`.
5. Access HASS Configurator at `http://localhost:3218` to edit configurations.

## SSL Configuration

- If using a reverse proxy like Caddy, ensure it is configured to handle SSL.
- To use SSL certificates downloaded using Certbot from the tool-stack, add the following to your Home Assistant `configuration.yml`:
  ```
  http:
    ssl_certificate: /var/lib/letsencrypt/fullchain.pem
    ssl_key: /var/lib/letsencrypt/privkey.pem
    use_x_forwarded_for: true
  ```

## Troubleshooting

- **MariaDB Access Denied**: If the database is already initialized, the init script won't run. Manually grant permissions:
  ```
  docker exec -it core-mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'homeassistant'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; FLUSH PRIVILEGES;"
  ```
  Replace the variables with values from `.env`.

## Configuration Files

- **init.sh** (`./config/mariadb-init/init.sh`): Initialization script for MariaDB. It grants privileges to the Home Assistant user on the database. Ensure it is executable (`chmod +x ./config/mariadb-init/init.sh`).
- **settings.conf** (`./config/configurator/settings.conf`): Configuration for HASS Configurator. It sets the base path to `/hass-config`, enforces base path usage, and lists directories first in the interface.

## Notes

- Ensure ports are not conflicting on your host.
- Backup `./config` directories regularly using external tools.
- Home Assistant Core does not include the built-in backup integration; use external tools instead.
- For external MariaDB access, the user permissions are set via the init script.
