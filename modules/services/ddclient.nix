{
    lib,
    pkgs,
    ...
}: {
    services.ddclient = {
        enable = true;
        package = pkgs.ddclient.overrideAttrs (finalAttrs: prevAttrs: let
            myPerl = pkgs.perl.withPackages (ps: [ps.JSONPP ps.JSON]);
        in {
            src = pkgs.fetchFromGitHub {
                owner = "lecram89";
                repo = "ddclient";
                rev = "b5de789be94bd50691e95af59ddb5fa75e6eeb0d";
                sha256 = "aIfpDAKGAiA4qQ/IU22sc9OkGlQfkOpx17dQ913ZxMw=";
            };

            buildInputs = with pkgs; [
                curl
                myPerl
            ];

            configureFlags = [
                "--with-perl=${lib.getExe myPerl}"
            ];
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
