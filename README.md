# CUPS printing server with Canon drivers

Docker Hub: https://hub.docker.com/r/manuelklaer/cups-canon

## Architectures
- linux/amd64
- linux/arm64
- linux/i386
- linux/mips64el

## Included packages:
- cups, cups-client, cups-bsd, cups-filters
- foomatic-db
- printer-driver-all, printer-driver-cups-pdf
- openprinting-ppds
- hpijs-ppds, hp-ppd, hplip
- cnijfilter2
- sudo, whois, usbutlis, smbclient

## Usage
### Start the container

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups manuelklaer/cups-canon:latest
```

### Configuration

Login in to CUPS web interface on port 631 (e.g. https://localhost:631) and configure CUPS to your needs.
Default credentials: admin / admin

To change the admin password set the environment variable _ADMIN_PASSWORD_ to your password.

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups -e ADMIN_PASSWORD=mySecretPassword manuelklaer/cups-canon:latest
```

---

_Forked from: https://gitlab.com/ydkn/docker-cups_ <br>
_Forked from: https://github.com/olbat/dockerfiles/tree/master/cupsd_
