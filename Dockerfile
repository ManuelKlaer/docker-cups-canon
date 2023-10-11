# base image
FROM amd64/debian:stable-slim

# args
ARG BUILD_DATE

# environment
ENV ADMIN_PASSWORD=admin

# labels
LABEL \
  maintainer="ManuelKlaer" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="manuelklaer/cups-canon" \
  org.label-schema.description="CUPS printing server with Canon drivers (cnijfilter2)" \
  org.label-schema.version="0.1" \
  org.label-schema.url="https://hub.docker.com/r/manuelklaer/cups-canon" \
  org.label-schema.vcs-url="https://github.com/ManuelKlaer/docker-cups-canon" \
  org.label-schema.build-date=$BUILD_DATE

# install cups server and drivers
RUN apt-get update \
  && apt-get install -y \
  sudo \
  whois \
  usbutils \
  smbclient \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  printer-driver-cups-pdf \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip

# add and install cnijfilter package
ADD cnijfilter2/cnijfilter2_6.60-1_amd64.deb /tmp/cnijfilter2.deb
RUN apt-get install -y /tmp/cnijfilter2.deb

# upgrade all packages
RUN apt-get update \
  && apt-get upgrade -y

# cleanup
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /tmp/cnijfilter2.deb

# add admin user
RUN adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin \
  && adduser admin sudo \
  && adduser admin lp \
  && adduser admin lpadmin

# disable sudo password checking
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid) \
  && echo "ServerAlias *" >> /etc/cups/cupsd.conf

# copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

# default command
CMD ["cupsd", "-f"]

# volumes
VOLUME ["/etc/cups"]

# ports
EXPOSE 631
