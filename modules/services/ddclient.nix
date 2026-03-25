{pkgs, ...}: {
    services.ddclient = {
        enable = true;
        package = pkgs.ddclient.overrideAttrs (finalAttrs: prevAttrs: {
            src = pkgs.fetchFromGitHub {
                owner = "cr3";
                repo = "ddclient";
                rev = "317584302907f21aceac49f2927804a5ac256052";
                sha256 = "7kovqy4ur2CALXK7QTOt+wBc/vL4uWPbQrnLMWRMyV4=";
            };
        });
        protocol = "hetznercloud";
        passwordFile = "/persist/passwords/hetzner";
        zone = "30350n.de";
        domains = [
            "home.30350n.de"
            "mc.30350n.de"
        ];
    };
}
