{config, ...}: {
    services.apartment-bot = {
        enable = true;
        environmentFile = "/persist/passwords/apartment-bot.env";
        configFile = "/var/lib/apartment-bot/config.toml";
    };

    services.caddy.virtualHosts."apartment-bot.home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.apartment-bot.port}
    '';

    services.unbound.settings.server.local-data = [
        ''"apartment-bot.home.internal. IN A 192.168.178.2"''
    ];

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/apartment-bot";
            inherit (config.services.apartment-bot) user;
        }
    ];
}
