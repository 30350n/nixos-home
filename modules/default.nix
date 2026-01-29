{
    lib,
    pkgs,
    ...
}: {
    imports = lib.nixos-core.autoImport ./.;

    boot.loader.systemd-boot.enable = true;

    environment.systemPackages = with pkgs; [
        nettools
        nixd
    ];

    hardware.graphics.enable = true;

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
    };

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    system.stateVersion = "25.11";
}
