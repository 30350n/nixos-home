{
    networking = {
        hostName = "nixos-home";
        useNetworkd = true;
    };

    systemd.network = {
        enable = true;
        networks."10-lan" = {
            matchConfig.Name = "enp4s0";
            networkConfig.DHCP = "ipv4";
        };
    };
}
