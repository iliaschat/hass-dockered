# Tool Stack Docker Compose

This directory contains a `docker-compose.yml` file that defines a Docker-based tool stack for reverse proxy, SSL, Zigbee integration, MQTT messaging, and backups.

## Overview

The `docker-compose.yml` file sets up the following services:

- **reverse-proxy-caddy**: A reverse proxy and SSL certificate manager using Caddy for handling HTTPS and routing.
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
- **DOMAIN_EMAIL**: Email for SSL certificate notifications (used by Caddy).
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
   - Caddy (reverse proxy): `https://localhost` (or your domain)
   - deCONZ: `http://localhost:8080`
   - Mosquitto: Ports 1883 (MQTT) and 9001 (WebSocket)
   - Duplicati: `http://localhost:8200`
4. Stop the stack: `docker-compose down`

## Configuration

- **reverse-proxy-caddy**: Configured via `./config/caddy/Caddyfile`; handles SSL certificates automatically; data and config persist in volumes.
- **deconz**: Uses host networking; Zigbee device mapped to `/dev/ttyUSB0`; config stored in `./config/deconz`.
- **mosquitto**: Uses host networking; config, data, and logs in `./config/mosquitto`.
- **duplicati**: Config in `./config/duplicati`; backs up `./config/hass_config`; uses host networking.
- Networks: Uses `docker-network` for Caddy and `hass-network` as an alternative.

## Troubleshooting

- Check logs: `docker-compose logs [service_name]`
- Ensure environment variables are set correctly.
- For deCONZ, verify Zigbee USB device access and permissions.
- For Caddy SSL issues, check domain configuration and email for Let's Encrypt.
- For Mosquitto, ensure ports are not conflicting and ACLs are configured if needed.
- For Duplicati, verify encryption key and backup destinations.
