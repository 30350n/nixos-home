{pkgs, ...}: {
    services.ddclient = {
        enable = true;
        package = pkgs.ddclient.overrideAttrs (finalAttrs: prevAttrs: {
            src = pkgs.fetchFromGitHub {
                owner = "ddclient";
                repo = "ddclient";
                rev = "533f1f3ef4bda2fefc66ca704175158b9f59e0bc";
                sha256 = "u0ve3mttU9CkstfQmwER+MysIlA4YIWL53OQxgICmOo=";
            };
        });
        protocol = "hetzner";
        passwordFile = "/persist/passwords/hetzner";
        zone = "30350n.de";
        domains = [
            "home.30350n.de"
            "mc.30350n.de"
        ];
    };
}
