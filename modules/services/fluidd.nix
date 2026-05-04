{
    config,
    lib,
    pkgs,
    ...
}: let
    printers = {
        genius = "genius.internal";
        voron = "voron2.internal";
    };
in {
    services.fluidd = rec {
        enable = true;
        hostName = "fluidd.home.internal";
        package = let
            endpoints = lib.mapAttrsToList (name: _: "https://${hostName}/${name}") printers;
        in
            pkgs.fluidd.overrideAttrs (finalAttrs: prevAttrs: {
                nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ (with pkgs; [jq]);
                postBuild =
                    (prevAttrs.postBuild or "")
                    + ''
                        pushd dist/
                        jq '.endpoints += ["${lib.concatStringsSep "\", \"" endpoints}"]' \
                            config.json > config.json.tmp
                        mv config.json.tmp config.json
                        popd
                    '';
            });
    };

    services.caddy.virtualHosts."${config.services.fluidd.hostName}".extraConfig = ''
        root * ${config.services.fluidd.package}/share/fluidd/htdocs

        header /index.html Cache-Control "no-store, no-cache, must-revalidate"

        ${lib.concatMapAttrsStringSep "" (name: host: ''
            handle_path /${name}* {
                reverse_proxy http://${host}:7125
            }
        '')
        printers}

        handle {
            try_files {path} {path}/ /index.html
            file_server
        }
    '';

    services.unbound.settings.server.local-data = [
        ''"${config.services.fluidd.hostName}. IN A 192.168.178.2"''
    ];
}
