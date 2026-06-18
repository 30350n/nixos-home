{
    config,
    flake-inputs,
    pkgs,
    ...
}: let
    cfg = config.services.inventree;
in {
    imports = [
        "${flake-inputs.nixpkgs-unstable}/nixos/modules/services/misc/inventree.nix"
    ];

    services.inventree = {
        enable = true;
        package = pkgs.unstable.inventree;
        adminPasswordFile = "/persist/passwords/inventree-admin";
        domain = "inventree.home.internal";
    };

    services.caddy = let
        unixSocket = config.systemd.sockets.inventree-server.socketConfig.ListenStream;
    in {
        extraConfig = ''
            (inventree-cors-headers) {
                header Allow GET,HEAD,OPTIONS
                header Access-Control-Allow-Origin *
                header Access-Control-Allow-Methods GET,HEAD,OPTIONS
                header Access-Control-Allow-Headers Authorization,Content-Type,User-Agent,traceparent

                @cors_preflight{args[0]} method OPTIONS

                handle @cors_preflight{args[0]} {
                    respond "" 204
                }
            }
        '';
        virtualHosts.${cfg.domain}.extraConfig = ''
            encode gzip

            request_body {
                max_size 100MB
            }

            handle_path /static/* {
                import inventree-cors-headers static

                root * ${cfg.settings.INVENTREE_STATIC_ROOT}
                file_server
            }

            handle_path /media/* {
                import inventree-cors-headers media

                root * ${cfg.settings.INVENTREE_MEDIA_ROOT}
                file_server

                header Content-Disposition attachment

                forward_auth unix/${unixSocket} {
                    uri /auth/
                }
            }

            reverse_proxy unix/${unixSocket}
        '';
    };

    services.unbound.settings.server.local-data = [''"${cfg.domain}. IN A 192.168.178.2"''];

    nixos-core.impermanence.persist.directories = [
        {
            directory = cfg.dataDir;
            inherit (cfg) user;
        }
    ];
}
