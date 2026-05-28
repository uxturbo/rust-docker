# Rust Docker

Local Docker-based development environment for running a Rust Dedicated Server with Oxide/uMod support.

This repository is intended for local plugin development, testing, and fast iteration without installing the Rust server directly on the host system.

## Features

- Rust Dedicated Server installed via SteamCMD
- Oxide/uMod installed during image build
- Docker Compose based setup
- Local `src/` folder mounted into the Oxide plugins directory
- RCON enabled for local development
- Runs the server as a non-root user inside the container
- Minimal setup focused on plugin development

## Repository Structure

```text
.
├── compose.yaml
├── init.sh
├── container/
│   ├── Dockerfile
│   └── install-oxide.sh
└── src/
```

| Path | Purpose |
|---|---|
| `compose.yaml` | Defines the Rust server container, exposed ports, and plugin bind mount |
| `container/Dockerfile` | Builds the Rust Dedicated Server image and installs Oxide |
| `container/install-oxide.sh` | Downloads and installs the latest Oxide.Rust release |
| `init.sh` | Prepares the local `src/` plugin directory permissions |
| `src/` | Local plugin source folder mounted to `/srv/rust/oxide/plugins` |

## Requirements

- Docker
- Docker Compose
- Linux, macOS, or WSL2 on Windows

On Windows, WSL2 is recommended because Rust server file permissions and bind mounts behave more predictably there. Humanity created three operating systems and somehow still made file permissions feel like ritual magic.

## Setup

Clone the repository:

```bash
git clone https://github.com/uxturbo/rust-docker.git
cd rust-docker
```

Prepare the local plugin directory:

```bash
./init.sh
```

Build and start the server:

```bash
docker compose up --build
```

The first build downloads the Rust Dedicated Server through SteamCMD and installs Oxide/uMod.

## Ports

| Port | Protocol | Purpose |
|---|---:|---|
| `28015` | UDP | Rust game server |
| `28016` | TCP | RCON |

## Plugin Development

Place your Oxide/uMod plugin files inside the local `src/` directory:

```text
src/
└── MyPlugin.cs
```

The folder is mounted directly into the container:

```text
/srv/rust/oxide/plugins
```

Oxide automatically loads plugins from that directory. Tiny dopamine factory for server developers.

## Server Defaults

The container starts the Rust server with development-friendly defaults:

| Setting | Value |
|---|---|
| Hostname | `C470DEV` |
| Max players | `10` |
| World size | `1000` |
| Game mode | `vanilla` |
| Seed | `123456` |
| Server identity | `devserver` |
| RCON web | enabled |

These values are defined in `container/Dockerfile` inside the final `CMD`.

## RCON

RCON is enabled on port `28016`.

Default development password:

```text
super_secure_dev_password
```

Do not expose this setup publicly without changing the RCON password and reviewing the server configuration. The internet is basically a distributed stress test for bad defaults.

## Data Persistence

Currently, only the local `src/` folder is mounted into the container.

That means plugin files are kept on the host, but server-generated data inside the container is not designed as long-term persistent project state. If you recreate the container, server data may be lost.

For persistent development data, add a bind mount or Docker volume for `/srv/rust`.

Example:

```yaml
volumes:
  - type: bind
    source: ./src
    target: /srv/rust/oxide/plugins
  - type: bind
    source: ./data
    target: /srv/rust
```

## Common Commands

Start the server:

```bash
docker compose up
```

Rebuild the image:

```bash
docker compose up --build
```

Stop the server:

```bash
docker compose down
```

Open a shell inside the container:

```bash
docker exec -it rust-server bash
```

Follow logs:

```bash
docker logs -f rust-server
```

## Security Notes

This setup is intentionally optimized for local development.

Before using it outside a trusted local environment:

- Change the RCON password
- Review exposed ports
- Add persistent data handling
- Avoid publishing private plugins in `src/`
- Review all bind mounts and file permissions

## License

MIT