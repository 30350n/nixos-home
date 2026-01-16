{pkgs, ...}: {
    powerManagement = {
        cpuFreqGovernor = "powersave";
        powertop.enable = true;
    };

    services.autoaspm.enable = true;

    environment.systemPackages = with pkgs; [
        pciutils
        powertop
    ];
}
