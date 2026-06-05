# System Stack Docker Compose

This directory contains a `docker-compose.yml` file that defines a Docker-based system stack for container management, dynamic DNS, and VPN access.

## Overview

The `docker-compose.yml` file sets up the following services:

- **Portainer**: A web-based Docker management interface for monitoring and managing containers.
- **DuckDNS**: A dynamic DNS updater to keep your domain pointing to your changing IP address.
- **OpenVPN Access Server**: A VPN server for secure remote access to your network.

## Prerequisites

- Docker and Docker Compose installed on your system.
- Environment variables set (e.g., PUID, PGID, TZ, DUCKDNS_SUBDOMAINS, DUCKDNS_TOKEN) for DuckDNS.
- Sufficient permissions for Docker socket access (for Portainer) and TUN device (for OpenVPN).

## Environment Variables

The following environment variables are required and should be defined in a `.env` file in the parent folder (`<hass-dockered>` - the root folder of this repository):

- **PUID**: User ID for file permissions (e.g., 1000).
- **PGID**: Group ID for file permissions (e.g., 1000).
- **TZ**: Timezone (e.g., America/New_York).
- **DUCKDNS_SUBDOMAINS**: Your DuckDNS subdomain(s), comma-separated if multiple.
- **DUCKDNS_TOKEN**: Your DuckDNS token for authentication.

Example `.env` file content:

```text
PUID=1000
PGID=1000
TZ=America/New_York
DUCKDNS_SUBDOMAINS=yourdomain
DUCKDNS_TOKEN=your_token_here
```

## Usage

1. Navigate to this directory: `cd <hass-dockered>/sys-stack`
2. Start the stack using the `.env` file from the parent folder: `docker-compose --env-file ../.env up -d`
3. Access services:
   - Portainer at `https://localhost:9443`
   - OpenVPN Access Server at `https://localhost:943` or `https://localhost:443`
4. Stop the stack: `docker-compose down`

## Configuration

- **Portainer**: Uses Docker socket for management; data persists in `portainer_data` volume.
- **DuckDNS**: Configured via environment variables; config stored in `./config/duckdns`.
- **OpenVPN Access Server**: Config stored in `./config/openvpn`; exposes ports for web UI and VPN connections.
- Networks: Uses `portainer_network` (default) and `hass-network` for connectivity.

## Troubleshooting

- Check logs: `docker-compose logs [service_name]`
- Ensure environment variables are set correctly for DuckDNS.
- For OpenVPN issues, verify TUN device access and firewall rules.
