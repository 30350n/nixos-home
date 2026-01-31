{config, ...}: {
    services.cockpit = {
        enable = true;
        allowed-origins = ["https://cockpit.home.internal"];
    };

    services.caddy.virtualHosts."cockpit.home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.cockpit.port}
    '';

    services.unbound.settings.server.local-data = [''"cockpit.home.internal. IN A 192.168.178.2"''];
}
