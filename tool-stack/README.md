# Tool Stack Docker Compose

This directory contains a `docker-compose.yml` file that defines a Docker-based tool stack for SSL certificate management, Zigbee integration, MQTT messaging, and backups.

## Overview

The `docker-compose.yml` file sets up the following services:

- **certbot**: SSL certificate manager using Certbot for obtaining and renewing Let's Encrypt certificates.
- **deconz**: A Zigbee gateway for smart home devices, providing web interface and API access.
- **mosquitto**: An MQTT broker for lightweight messaging between IoT devices.
- **duplicati**: A backup solution for encrypting and storing data remotely.

## Prerequisites

- Docker and Docker Compose installed on your system.
- Environment variables set (e.g., TZ, PUID, PGID, DUPLICATI_ENCRYPTION_KEY, DUPLICATI_WEBSERVICE_PASSWORD, DOMAIN_EMAIL, DUCKDNS_DOMAIN) for configuration.
- Access to required devices (e.g., Zigbee USB for deCONZ).
- Internet connection for DNS and certificate management.

## Environment Variables

The following environment variables are required and should be defined in a `.env` file in the parent folder (`<hass-dockered>` - the root folder of this repository):

- **TZ**: Timezone (e.g., America/New_York).
- **PUID**: User ID for file permissions (e.g., 1000).
- **PGID**: Group ID for file permissions (e.g., 1000).
- **DUPLICATI_ENCRYPTION_KEY**: Encryption key for Duplicati backups.
- **DUPLICATI_WEBSERVICE_PASSWORD**: Password for Duplicati web interface.
- **DOMAIN_EMAIL**: Email for SSL certificate notifications (used by Certbot).
- **DUCKDNS_DOMAIN**: Your DuckDNS domain for SSL (e.g., yourdomain.duckdns.org).

Example `.env` file content:

```text
TZ=America/New_York
PUID=1000
PGID=1000
DUPLICATI_ENCRYPTION_KEY=your_encryption_key
DUPLICATI_WEBSERVICE_PASSWORD=your_password
DOMAIN_EMAIL=your_email@example.com
DUCKDNS_DOMAIN=yourdomain.duckdns.org
```

## Usage

1. Navigate to this directory: `cd <hass-dockered>/tool-stack`
2. Start the stack using the `.env` file from the parent folder: `docker-compose --env-file ../.env up -d`
3. Access services:
   - deCONZ: `http://localhost:8080`
   - Mosquitto: Ports 1883 (MQTT) and 9001 (WebSocket)
   - Duplicati: `http://localhost:8200`
   - Certbot: Runs in the background to obtain certificates; no direct web access.
4. Stop the stack: `docker-compose down`

## Configuration

- **certbot**: Configured via command-line arguments; certificates stored in `./config/letsencrypt` and `./config/certbot`; uses standalone mode for domain validation.
- **deconz**: Uses host networking; Zigbee device mapped to `/dev/ttyUSB0`; config stored in `./config/deconz`.
- **mosquitto**: Uses host networking; config, data, and logs in `./config/mosquitto`.
- **duplicati**: Config in `./config/duplicati`; backs up `./config/hass_config`; uses host networking.
- Networks: Uses `hass-network` for Certbot.

## Troubleshooting

- Check logs: `docker-compose logs [service_name]`
- Ensure environment variables are set correctly for Certbot and Duplicati.
- For Certbot SSL issues, verify domain ownership and email; certificates are renewed automatically if the container runs periodically.
- For deCONZ, verify Zigbee USB device access and permissions.
- For Mosquitto, ensure ports are not conflicting and ACLs are configured if needed.
- For Duplicati, verify encryption key and backup destinations.
