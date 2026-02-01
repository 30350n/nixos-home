{config, ...}: {
    imports = [
        ./mqtt.nix
    ];

    services.home-assistant = {
        enable = true;
        extraComponents = [
            "isal"

            "airgradient"
            "mqtt"
            "sleep_as_android"
        ];

        config = {
            http = {
                use_x_forwarded_for = true;
                trusted_proxies = [
                    "127.0.0.1"
                    "::1"
                ];
            };

            default_config = {};
            homeassistant.time_zone = null;

            "automation ui" = "!include automations.yaml";
            "script ui" = "!include scripts.yaml";
            "scene ui" = "!include scenes.yaml";
        };
    };

    networking.firewall.allowedTCPPorts = [config.services.home-assistant.config.http.server_port];

    systemd.tmpfiles.rules = let
        configDir = config.services.home-assistant.configDir;
    in [
        "f ${configDir}/automations.yaml 0644 hass hass"
        "f ${configDir}/scripts.yaml 0644 hass hass"
        "f ${configDir}/scenes.yaml 0644 hass hass"
    ];

    services.caddy.virtualHosts."home-assistant.home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.home-assistant.config.http.server_port}
    '';

    services.unbound.settings.server.local-data = [
        ''"home-assistant.home.internal. IN A 192.168.178.2"''
    ];

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/hass";
            user = config.systemd.services.home-assistant.serviceConfig.User;
        }
    ];
}
