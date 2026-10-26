{pkgs, ...}: {
    services.ddclient = {
        enable = true;
        package = pkgs.ddclient.overrideAttrs (finalAttrs: prevAttrs: {
            src = pkgs.fetchFromGitHub {
                owner = "ddclient";
                repo = "ddclient";
                rev = "v4.0.1-rc.1";
                hash = "sha256-VPZnE34Mz2QqMrLA2ZDapcc8zfvBQhHMAw3w056lAM8=";
            };
        });
        protocol = "hetzner";
        passwordFile = "/persist/passwords/hetzner";
        zone = "30350n.de";
        domains = ["home.30350n.de"];
    };
}
