FROM registry.suse.com/bci/bci-init:15.3

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    ADDITIONAL_MODULES="PackageHub,sle-module-desktop-applications,sle-we" zypper --non-interactive --gpg-auto-import-keys in \
      fluxbox \
      git-core \
      net-tools \
      novnc \
      supervisor \
      x11vnc \
      xterm \
      python3-cryptography python3-PyJWT \
      xvfb-run dosbox unzip

RUN sed -i -e "s/(uri, protocols);/(uri, ['binary', 'base64']);/g" /usr/share/novnc/core/websock.js

COPY dosbox.conf /root/.dosbox/dosbox-0.74-3.conf
### get games from https://dosgames.com/

### Add games to image...
# COPY game1.tar.gz /root/dos/game1
# COPY game2 /root/dos/game2
COPY DOSBOX_SSF2T.ZIP /tmp
RUN unzip /tmp/DOSBOX_SSF2T.ZIP -d /root/dos/ && zypper --non-interactive rm unzip


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
    RUN_FLUXBOX=yes

ENV RUN_XTERM=no
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ADD conf.d /app/conf.d
COPY  entrypoint.sh supervisord.conf /app/
CMD ["/app/entrypoint.sh"]
EXPOSE 8080
