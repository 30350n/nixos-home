{config, ...}: {
    services.caddy = {
        enable = true;

        globalConfig = ''
            local_certs
        '';

        virtualHosts."cert.home.internal".extraConfig = ''
            @any {
                not path /
            }
            redir @any /
            handle / {
                root * /var/lib/caddy/.local/share/caddy/pki/authorities/local/
                rewrite * /root.crt
                header {
                    Content-Disposition "attachment; filename=root.crt"
                    Content-Type "application/x-x509-ca-cert"
                }
                file_server
            }
        '';
    };

    services.unbound.settings.server.local-data = [''"cert.home.internal. IN A 192.168.178.2"''];

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/caddy";
            inherit (config.services.caddy) user;
        }
    ];

    networking.firewall.allowedTCPPorts = [80 443];
}
