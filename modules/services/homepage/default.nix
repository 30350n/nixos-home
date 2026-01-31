{
    config,
    lib,
    ...
}: {
    services.homepage-dashboard = {
        enable = true;
        allowedHosts = "home.internal";

        widgets = [
            {
                greeting = {
                    text_size = "2xl";
                    text = "nixos-home";
                };
            }
            {
                resources = {
                    cpu = true;
                    memory = true;
                    uptime = true;
                    disk = "/persist";
                };
            }
            {
                openmeteo = {
                    label = "Berlin";
                    latitude = 52.4915;
                    longitude = 13.4880;
                    units = "metric";
                };
            }
            {
                datetime = {
                    text_size = "2xl";
                    format = {
                        timeStyle = "short";
                        hourCycle = "h23";
                    };
                };
            }
        ];

        services = lib.mkAfter [
            {
                Services = let
                    api-keys =
                        if (builtins.pathExists ./api-keys.nix)
                        then (import ./api-keys.nix)
                        else lib.genAttrs ["home-assistant"] (_: "");
                in [
                    {
                        "Home Assistant" = rec {
                            icon = "home-assistant.svg";
                            href = "https://home-assistant.home.internal";
                            siteMonitor = href;
                            widget = {
                                type = "homeassistant";
                                url = href;
                                key = api-keys.home-assistant;
                            };
                        };
                    }
                ];
            }
            {
                Administration = [
                    {
                        Cockpit = rec {
                            icon = "cockpit-light.svg";
                            href = "https://cockpit.home.internal";
                            siteMonitor = href;
                        };
                    }
                    {
                        "FRITZ!Box" = rec {
                            icon = "avm-fritzbox.svg";
                            href = "http://fritz.box";
                            siteMonitor = href;
                            widget = {
                                type = "fritzbox";
                                url = "http://192.168.178.1";
                            };
                        };
                    }
                ];
            }
        ];

        settings = {
            title = config.networking.hostName;
            color = "neutral";
            headerStyle = "boxed";
            statusStyle = "dot";

            layout = [
                {Services.style = "column";}
                {Administration.style = "column";}
            ];
        };

        customCSS = builtins.readFile ./custom.css;
    };

    services.caddy.virtualHosts."home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}
    '';
}
