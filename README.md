# CUPS printing server with Canon drivers

Docker Hub: https://hub.docker.com/r/manuelklaer/cups-canon

## Architectures
- linux/amd64
- linux/arm64
- linux/i386
- linux/mips64el

## Included packages:
- cups, cups-client, cups-bsd, cups-filters, cups-browsed
- foomatic-db-engine, foomatic-db-compressed-ppds
- printer-driver-all, printer-driver-cups-pdf
- openprinting-ppds
- hpijs-ppds, hp-ppd, hplip
- [cnijfilter2 6.80-1](https://canoncanada.custhelp.com/app/answers/answer_view/a_id/1048834/~/ij-printer-driver-ver.-6.80-for-linux-%28debian-packagearchive%29)
- sudo, whois, usbutlis, smbclient, avahi-utils

## Usage
### Start the container

```bash
docker run -d --restart always -p 631:631 -v ./cups:/etc/cups manuelklaer/cups-canon:latest
```

### Configuration

Login in to CUPS web interface on port 631 (e.g. https://localhost:631) and configure CUPS to your needs.
Default credentials: admin / admin

To change the admin password set the environment variable _ADMIN_PASSWORD_ to your password.

```bash
docker run -d --restart always -p 631:631 -v ./cups:/etc/cups -e ADMIN_PASSWORD=mySecretPassword manuelklaer/cups-canon:latest
```

---

_Forked from: https://gitlab.com/ydkn/docker-cups_ <br>
_Forked from: https://github.com/olbat/dockerfiles/tree/master/cupsd_
