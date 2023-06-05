FROM registry.suse.com/bci/bci-base:latest
ARG GAME_ZIP
ARG LAUNCH_CMD
ARG DISPLAY_WIDTH=1027
ARG DISPLAY_HEIGHT=768
ENV ADDITIONAL_MODULES="PackageHub,sle-module-desktop-applications,sle-we"

RUN --mount=type=secret,id=SCCcredentials \
     zypper --non-interactive --gpg-auto-import-keys in \
      fluxbox \
      git-core \
      net-tools \
      novnc \
      supervisor \
      x11vnc \
      xterm \
      python3-cryptography python3-PyJWT \
      xvfb-run dosbox unzip && \
    zypper --non-interactive clean

RUN sed -i -e "s/(uri, protocols);/(uri, ['binary', 'base64']);/g" /usr/share/novnc/core/websock.js

COPY dosbox.conf /root/.dosbox/dosbox-0.74-3.conf
RUN sed -i "s/LAUNCH_CMD/$LAUNCH_CMD/" /root/.dosbox/dosbox-0.74-3.conf
### get games from https://dosgames.com/

### Add games to image...
# COPY game1.tar.gz /root/dos/game1
# COPY game2 /root/dos/game2
COPY $GAME_ZIP /tmp
RUN unzip /tmp/$GAME_ZIP -d /root/dos/

### ... or use from volume
# VOLUME /root/dos/

# Setup demo environment variables
ENV HOME=/root \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes \
    RUN_XTERM=no

ENV DISPLAY_WIDTH=$DISPLAY_WIDTH
ENV DISPLAY_HEIGHT=$DISPLAY_HEIGHT
ADD conf.d /app/conf.d
COPY entrypoint.sh supervisord.conf /app/
CMD ["/app/entrypoint.sh"]
EXPOSE 8080
