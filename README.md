# CUPS printing server with Canon drivers

_Forked from: https://gitlab.com/ydkn/docker-cups_

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
