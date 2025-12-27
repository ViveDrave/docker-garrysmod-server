FROM ubuntu:22.04

LABEL MAINTAINER="_AMD_ (me@amd-nick.me)"
ARG STEAM_USER
ARG STEAM_PASS

# Prepare Gmod server and CSS content
# ===================================

RUN dpkg --add-architecture i386 \
	&& apt update \
	&& apt -y upgrade \
	&& apt -y --no-install-recommends install curl lib32stdc++6 libtinfo5:i386 ca-certificates
#                                                  /\ for steamcmd  /\ fixes readline: https://forum.gm-donate.net/t/7645


# Cleanup
# ===================================

RUN apt-get clean \
	&& rm -rf /tmp/* /var/lib/apt/lists/*


# Security
# P.S. 25.04 has default user ubuntu 1000:1000
# ===================================

RUN groupadd -g 1000 steam \
	&& useradd -r -m -d /gmodserv -u 1000 -g steam steam

USER steam
ENV HOME=/gmodserv


# SteamCMD + GMOD + CSS
# ===================================

WORKDIR /gmodserv/steamcmd

RUN curl -O https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
	&& tar -xvzf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz

RUN ./steamcmd.sh \
	+force_install_dir /gmodserv/content/css \
	+login $STEAM_USER $STEAM_PASS \
	+app_update 232330 -validate \
	+quit

RUN ./steamcmd.sh \
	+force_install_dir /gmodserv \
	+login $STEAM_USER $STEAM_PASS \
	+app_update 4020 -validate \
	+quit

RUN echo '"mountcfg" {"cstrike" "/gmodserv/content/css/cstrike"}' > /gmodserv/garrysmod/cfg/mount.cfg


# Run server
# ===================================

WORKDIR /gmodserv
ENTRYPOINT ["./srcds_run", "-game garrysmod", "-console", "-norestart", "-strictportbind"]
CMD ["-port 27015", "-tickrate 32", "-maxplayers 16", "-insecure", "+map gm_construct"]
