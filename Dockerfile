ARG DEBIAN_DIST=bookworm
FROM debian:$DEBIAN_DIST

ARG DEBIAN_DIST
ARG VERSION
ARG BUILD_VERSION
ARG FULL_VERSION

RUN apt update && apt install -y wget git make build-essential libdb-dev zlib1g-dev libgpgme-dev libbz2-dev
RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/reprepro-multi-version
RUN cd /tmp && git clone https://github.com/dariogriffo/reprepro-multi-version
RUN cd /tmp/reprepro-multi-version && ./configure && make
RUN cd /tmp/reprepro-multi-version && cp reprepro /output/usr/bin/
RUN mkdir -p /output/DEBIAN
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/reprepro-multi-version/
COPY output/changelog.Debian /output/usr/share/doc/reprepro-multi-version/
COPY output/README.md /output/usr/share/doc/reprepro-multi-version/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/reprepro-multi-version/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/reprepro-multi-version/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/VERSION/$VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control

RUN dpkg-deb --build /output /reprepro-multi-version_${FULL_VERSION}.deb
