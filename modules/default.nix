{
    config,
    lib,
    pkgs,
    ...
}: {
    imports =
        lib.nixos-core.autoImport ./.
        ++ lib.nixos-core.autoImport ./services;

    boot.loader.systemd-boot.enable = true;

    environment.systemPackages = with pkgs; [
        nettools
        nixd
    ];

    hardware.graphics.enable = true;

    services.caddy = {
        enable = true;
        globalConfig = ''
            local_certs
        '';
    };
    networking.firewall.allowedTCPPorts = [80 443];

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
    };

    nixos-core.impermanence.persist.directories = [
        "/root/.vscodium-server"
        {
            directory = "/var/lib/caddy";
            inherit (config.services.caddy) user;
        }
    ];

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    system.stateVersion = "25.11";
}
