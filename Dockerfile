# base image
FROM amd64/debian:buster-slim

# args
ARG BUILD_DATE

# environment
ENV ADMIN_PASSWORD=admin

# labels
LABEL maintainer="ManuelKlaer" \
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
  cups \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip

# add cnijfilter package
ADD cnijfilter2_5.50-1_amd64.deb /tmp/cnijfilter2.deb

# install cnijfilter2
RUN apt-get install -y /tmp/cnijfilter2.deb

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
