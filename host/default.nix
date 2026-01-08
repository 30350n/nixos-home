{
    imports = [
        ./hardware-configuration.nix
        (import ./disko.nix {devices = import ./devices.nix;})
    ];

    networking.hostId = import ./host-id.nix;

    nixos-core.impermanence = {
        enable = true;
        persistFileSystem = "/persist";
        resetCommands = "zfs rollback -r zroot/root@blank";
    };
}
