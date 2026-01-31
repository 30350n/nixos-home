{config, ...}: {
    services.mosquitto = {
        enable = true;
        listeners = [
            {
                acl = ["pattern readwrite #"];
                omitPasswordAuth = true;
                settings.allow_anonymous = true;
            }
        ];
    };

    services.zigbee2mqtt = {
        enable = true;
        settings = {
            homeassistant.enabled = true;
            permit_join = true;
            server = "mqtt://localhost:1883";
            serial = {
                adapter = "ember";
                port = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
            };
        };
    };

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/mosquitto";
            user = config.systemd.services.mosquitto.serviceConfig.User;
        }
        {
            directory = "/var/lib/zigbee2mqtt";
            user = config.systemd.services.zigbee2mqtt.serviceConfig.User;
        }
    ];
}
