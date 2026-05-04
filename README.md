# nixos-home

## Router Setup

### Static IPs

```
|  Hostname                 |      Domain       |   IP Address    |
| ------------------------- | ----------------- | --------------- |
| FRITZ!Box                 | fritz.box         | 192.168.178.1   |
| nixos-home                | home.internal     | 192.168.178.2   |
| ------------------------- | ----------------- | --------------- |
| desktop                   | desktop.internal  | 192.168.178.10  |
| thinkpad                  | thinkpad.internal | 192.168.178.11  |
| nixos-voron2              | voron2.internal   | 192.168.178.12  |
| nixos-artillery-genius    | genius.internal   | 192.168.178.13  |
| ------------------------- | ----------------- | --------------- |
| airgradient-diy-v4        |         -         | 192.168.178.101 |
```

### DNS Server

- DNSv4 Server: `192.168.178.2`
