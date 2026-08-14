FROM ubuntu:26.04 AS source

ADD --checksum=sha256:fd78efb1ffa0907a525784462494b9b42938f9fd7c019f3eaea3b8faf837e8c1 https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.15.1/ProtonUp-Qt-2.15.1-x86_64.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/protonup-qt"

COPY --from=source /out /opt/protonup-qt
COPY protonup-qt /usr/bin/protonup-qt
COPY net.davidotek.pupgui2.desktop /usr/share/applications/net.davidotek.pupgui2.desktop

RUN chmod 0755 /usr/bin/protonup-qt && \
    if [ -e /opt/protonup-qt/.DirIcon ]; then install -Dm644 /opt/protonup-qt/.DirIcon /usr/share/icons/hicolor/256x256/apps/net.davidotek.pupgui2.png; fi && \
    cpak-clean-junk
