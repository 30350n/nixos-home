{config, ...}: {
    services.immich = {
        enable = true;
        openFirewall = true;
        accelerationDevices = ["/dev/dri/renderD128"];
    };

    users.users.immich.extraGroups = ["render" "video"];

    services.caddy.virtualHosts."immich.home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.immich.port}
    '';

    services.unbound.settings.server.local-data = [''"immich.home.internal. IN A 192.168.178.2"''];

    nixos-core.impermanence.persist.directories = [
        {
            directory = config.services.immich.mediaLocation;
            inherit (config.services.immich) user;
        }
    ];
}
