{
    config,
    pkgs,
    ...
}: {
    services.unbound = {
        enable = true;
        settings = {
            server = {
                interface = [
                    "192.168.178.2"
                    "fe80::1e83:41ff:fe31:d608"
                    "127.0.0.1"
                    "::1"
                ];
                access-control = [
                    "192.168.178.0/24 allow"
                    "fe80::/10 allow"
                    "127.0.0.0/8 allow"
                    "::1/128 allow"
                ];
                include = "${pkgs.callPackage ./adblock.nix {}}";

                local-zone = ''"home.internal." static'';
                local-data = [''"home.internal. IN A 192.168.178.2"''];
            };

            forward-zone = [
                {
                    name = ''"fritz.box"'';
                    forward-addr = ["192.168.178.1"];
                }
            ];
        };
    };

    networking.firewall = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53];
    };

    services.resolved.enable = false;

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/unbound";
            inherit (config.services.unbound) user;
        }
    ];
}
