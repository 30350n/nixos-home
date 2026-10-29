# nixos-home

## Router Setup

### Static IPs

```
|  Hostname              |      Domain       |   IP Address    |
| ---------------------- | ----------------- | --------------- |
| FRITZ!Box              | fritz.box         | 192.168.178.1   |
| nixos-home             | home.internal     | 192.168.178.2   |
| ---------------------- | ----------------- | --------------- |
| desktop                | desktop.internal  | 192.168.178.10  |
| thinkpad               | thinkpad.internal | 192.168.178.11  |
| nixos-voron2           | voron2.internal   | 192.168.178.12  |
| nixos-artillery-genius | genius.internal   | 192.168.178.13  |
| ---------------------- | ----------------- | --------------- |
| airgradient-diy-v4     |         -         | 192.168.178.101 |
```

### Port Forwarding

```
|  Hostname                 |  Service  |  TCP  |  UDP  |
| ------------------------- | --------- | ----- | ----- |
| nixos-home                | wireguard |   -   | 51820 |
| ------------------------- | --------- | ------|------ |
| desktop                   | minecraft | 25565 | 25565 |
```

### DNS Server

FRITZ!Box Settings: *Home Network -> Network -> Network Settings*

- DNSv4 Server: `192.168.178.2` ([*IPv4 Settings -> Local DNS server*](http://fritz.box/#boxnet))
- DNSv6 Server: `fe80::1e83:41ff:fe31:d608` ([*IPv6 Settings -> DNSv6 Server in the Home Network*](http://fritz.box/#boxnet_ipv6))

## Immich

### Restoring Database

1. Temporarily give the immich postgres user superuser privileges:
   ```sh
   $ sudo -u postgres psql -c "ALTER USER immich WITH SUPERUSER;"
   ```
2. Restore the backup from the web UI.
3. Remove the superuser privileges again:
   ```sh
   $ sudo -u postgres psql -c "ALTER USER immich WITH NOSUPERUSER;"
   ```
