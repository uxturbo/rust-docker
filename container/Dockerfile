FROM steamcmd/steamcmd:debian-trixie AS install-stage

RUN steamcmd \
    +force_install_dir /srv/rust \
    +login anonymous \
    +app_update 258550 validate \
    +quit

FROM debian:trixie-slim

ARG MOD_FRAMEWORK=carbon

RUN groupadd -g 1000 rustgroup && \
    useradd -r -u 10001 -g rustgroup --create-home rust

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        lib32gcc-s1 \
        lib32stdc++6 \
        curl \
        unzip \
        netcat-traditional \
        gettext-base && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /srv/rust

COPY --from=install-stage /srv/rust /srv/rust

COPY container/install-oxide.sh /tmp/install-oxide.sh
COPY container/install-carbon.sh /tmp/install-carbon.sh

RUN chmod +x /tmp/install-oxide.sh /tmp/install-carbon.sh && \
    if [ "$MOD_FRAMEWORK" = "carbon" ]; then \
        echo "Installing Carbon framework..." && \
        /tmp/install-carbon.sh; \
    elif [ "$MOD_FRAMEWORK" = "oxide" ]; then \
        echo "Installing Oxide/uMod framework..." && \
        /tmp/install-oxide.sh; \
    elif [ "$MOD_FRAMEWORK" = "none" ]; then \
        echo "Skipping mod framework installation."; \
    else \
        echo "Unsupported MOD_FRAMEWORK: $MOD_FRAMEWORK" && \
        echo "Supported values: carbon, oxide, none" && \
        exit 1; \
    fi && \
    rm /tmp/install-oxide.sh /tmp/install-carbon.sh


COPY container/start-server.sh /usr/local/bin/start-server.sh
RUN chmod +x /usr/local/bin/start-server.sh && \
    if [ -f /srv/rust/carbon.sh ]; then chmod +x /srv/rust/carbon.sh; fi

USER rust

EXPOSE 28015/udp
EXPOSE 28016/tcp
CMD ["start-server.sh", "-batchmode", "-nographics", "+server.ip", "0.0.0.0", "+server.port", "28015", "+server.hostname", "RustDev", "+server.maxplayers", "10", "+server.worldsize", "1000", "+server.gamemode", "vanilla", "+server.seed", "123456", "+server.identity", "devserver", "+rcon.ip", "0.0.0.0", "+rcon.port", "28016", "+rcon.password", "super_secure_dev_password", "+rcon.web", "1", "+app.port", "0"]