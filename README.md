# Hass-Dockered

This repository contains Docker Compose configurations for a Home Assistant setup, organized into stacks: `hass` (Home Assistant core), `tool` (tools like Certbot, Deconz, Mosquitto, Duplicati), `sys` (system services like Portainer, DuckDNS, OpenVPN-AS), and `all` (runs all stacks).

## Profiles

- `basic`: Minimal setup (e.g., Home Assistant and DuckDNS).
- `extra`: Additional tools and services (e.g., Deconz, Mosquitto, Duplicati, Portainer, OpenVPN-AS).
- `full`: Complete setup with all services.

## Using run.sh

The `run.sh` script manages Docker Compose operations for the stacks.

### Syntax

```bash
./run.sh <operation> [stack] [profile]
```

- `<operation>`: `up` (start containers) or `down` (stop containers).
- `[stack]`: Optional. `all`, `sys`, `tool`, or `hass`. Defaults to `all`.
- `[profile]`: Optional. `basic`, `extra`, or `full`. Defaults to `basic`.

### Examples

- Start all stacks with default profile (`basic`): `./run.sh up`
- Start all stacks with `full` profile: `./run.sh up all full`
- Start only the `hass` stack with `extra` profile: `./run.sh up hass extra`
- Stop all stacks: `./run.sh down`

### Notes

- When `up` is used, containers start in detached mode.
- Ensure `.env` file is configured with required environment variables.
- Profiles control which services start based on the docker-compose.yml files.

## Overview

Hass-Dockered is designed to containerize Home Assistant and related components for easy deployment, management, and scaling. It uses Docker Compose to define services across three stacks: sys-stack (system utilities), tool-stack (integrations and backups), and hass-stack (core HA with database and configurator).

## Stacks

- **sys-stack**: Handles system-level services like Portainer (Docker management), DuckDNS (dynamic DNS), and OpenVPN Access Server (VPN access).
- **tool-stack**: Includes tools for SSL certificates & Reverse Proxy (Caddy), Zigbee gateway (deCONZ), MQTT broker (Mosquitto), and backups (Duplicati).
- **hass-stack**: Runs the core Home Assistant application with MariaDB (database) and HASS Configurator (web-based editor).

## Requirements

- Docker and Docker Compose installed on your system (see Installation below).
- Sufficient hardware resources (e.g., at least 2GB RAM for HA).
- Access to required devices (e.g., Zigbee USB for deCONZ).
- Internet connection for DNS updates and certificate issuance.

## Installation

1. Clone or download this repository to your local machine.
2. Install Docker: Follow the official guide at https://docs.docker.com/get-docker/.
3. Install Docker Compose: Included with Docker Desktop; for Linux, run `sudo apt-get install docker-compose` (or equivalent for your distro).
4. Ensure Docker is running: `sudo systemctl start docker` (Linux) or check Docker Desktop.
5. Make the script executable: `chmod +x run.sh`.

## Environment Setup

1. Create a `.env` file in the root directory (`hass-dockered` - the root folder of this repository).
2. Define the following variables based on your setup (see example below). Use secure, random values for passwords and keys. Generate strong passwords using tools like `openssl rand -base64 12`.

Example `.env` file:

```
# System Stack
PUID=1000
PGID=1000
TZ=America/New_York
DUCKDNS_SUBDOMAINS=yourdomain
DUCKDNS_TOKEN=your_token

# Tool Stack
DOMAIN_EMAIL=your_email@example.com
DUCKDNS_DOMAIN=yourdomain.duckdns.org
DUPLICATI_ENCRYPTION_KEY=your_encryption_key
DUPLICATI_WEBSERVICE_PASSWORD=your_password

# Hass Stack
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=homeassistant
MYSQL_USER=homeassistant
MYSQL_PASSWORD=your_password
```

## Usage

### (Simplified) Using run.sh

The `run.sh` script simplifies stack management. Ensure it's executable with `chmod +x run.sh`, then run it from the root directory.

- To start all stacks: `sh run.sh up`
- To stop all stacks: `sh run.sh down`
- To start a specific stack: `sh run.sh up [sys|tool|hass]` (e.g., `sh run.sh up hass`)
- To stop a specific stack: `sh run.sh down [sys|tool|hass]` (e.g., `sh run.sh down tool`)

### (Manual) Running Individual Stacks

- Navigate to each subfolder and run Docker Compose using the parent `.env` file.
- **sys-stack**: `cd sys-stack && docker-compose --env-file ../.env up -d`
- **tool-stack**: `cd tool-stack && docker-compose --env-file ../.env up -d`
- **hass-stack**: `cd hass-stack && docker-compose --env-file ../.env up -d`

### Accessing Services

- Home Assistant: `http://localhost:8123`
- HASS Configurator: `http://localhost:3218`
- Portainer: `https://localhost:9443`
- deCONZ: `http://localhost:8080`
- Duplicati: `http://localhost:8200`
- OpenVPN: `https://localhost:943`

### Stopping Services

- Run `docker-compose down` in each stack folder or use the script to stop all.

## Troubleshooting

- **Ensure `.env` variables are set correctly**: Missing or incorrect values can cause startup failures. Double-check against the example.
- **Check logs**: Run `docker-compose logs` in each stack folder or use `sh run.sh up` and inspect output for errors.
- **Port conflicts**: If ports are in use, stop conflicting services or change ports in docker-compose.yml files.
- **SSL issues**: Verify Caddy certificates are valid and HA config points to the correct paths. Renew certificates if expired.
- **Device access**: For deCONZ, ensure the Zigbee USB device is mapped correctly in the compose file and accessible.
- **Performance**: Monitor resource usage with `docker stats`. Increase RAM/CPU if HA is slow.
- **Common errors**: "Permission denied" – run with `sudo` or adjust Docker user permissions. "Network not found" – ensure networks are defined.
- Refer to individual stack READMEs or Docker documentation for specific issues. For HA-specific problems, check the Home Assistant community forums.
