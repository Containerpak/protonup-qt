FROM ubuntu:26.04 AS source

ARG APP_SHA256=fd78efb1ffa0907a525784462494b9b42938f9fd7c019f3eaea3b8faf837e8c1

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    curl --fail --location --output /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.15.1/ProtonUp-Qt-2.15.1-x86_64.AppImage" && \
    echo "${APP_SHA256}  /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage" | sha256sum --check

FROM ghcr.io/containerpak/gtk:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/protonup-qt"

COPY --from=source /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage
COPY protonup-qt /usr/bin/protonup-qt
COPY net.davidotek.pupgui2.desktop /usr/share/applications/net.davidotek.pupgui2.desktop

RUN apt-get update && \
    apt-get install -y --no-install-recommends squashfs-tools && \
    chmod +x /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage && \
    /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage --appimage-extract && \
    mv squashfs-root /opt/protonup-qt && \
    chmod 0755 /usr/bin/protonup-qt && \
    if [ -e /opt/protonup-qt/.DirIcon ]; then install -Dm644 /opt/protonup-qt/.DirIcon /usr/share/icons/hicolor/256x256/apps/net.davidotek.pupgui2.png; fi && \
    rm -rf /tmp/ProtonUp-Qt-2.15.1-x86_64.AppImage /tmp/archive && \
    cpak-clean-junk

