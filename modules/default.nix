{
    flake-inputs,
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
        restic
    ];

    hardware.graphics.enable = true;

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
    };

    nixos-core.impermanence.persist.directories = ["/root/.vscodium-server"];

    nix.settings = {
        substituters = ["http://desktop.internal:5000"];
        trusted-public-keys = ["desktop.local:F5aFStU6NcLoMeLYWJqCu97h23Fih400ANAqY1sMjBs="];
    };

    nixpkgs.overlays = [flake-inputs.nixos-core.overlays.unstable];

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    system.stateVersion = "25.11";
}
