{pkgs, ...}: {
    systemd.network = {
        networks."50-wg0" = {
            matchConfig.Name = "wg0";
            address = [
                "10.0.0.1/24"
                "fdc9:281f:04d7:9ee9::1/64"
            ];
            networkConfig = {
                IPv4Forwarding = true;
                IPv6Forwarding = true;
            };
        };

        netdevs."50-wg0" = {
            netdevConfig = {
                Kind = "wireguard";
                Name = "wg0";
            };
            wireguardConfig = {
                ListenPort = 51820;
                PrivateKeyFile = "/persist/passwords/wireguard/private";
                RouteTable = "main";
            };
            wireguardPeers = [
                {
                    # Samsung S21 FE
                    PublicKey = "ppXuK8gSQOcFhZPV1OASIjgedU1z+JbxE166wwgsl1U=";
                    AllowedIPs = [
                        "10.0.0.2/32"
                        "fdc9:281f:04d7:9ee9::2/128"
                    ];
                }
            ];
        };
    };

    networking.nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = "enp4s0";
        internalInterfaces = ["wg0"];
    };

    services.unbound.settings.server = {
        interface = [
            "10.0.0.1"
            "fdc9:281f:04d7:9ee9::1"
        ];
        access-control = [
            "10.0.0.0/24 allow"
            "fdc9:281f:04d7:9ee9::/64 allow"
        ];
    };

    networking.firewall.allowedUDPPorts = [51820];

    environment.systemPackages = with pkgs; [
        wireguard-tools
    ];
}
