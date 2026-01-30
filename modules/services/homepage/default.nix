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
                Administration = [
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
                {
                    Administration = {
                        style = "row";
                        columns = 3;
                    };
                }
            ];
        };

        customCSS = builtins.readFile ./custom.css;
    };

    services.caddy.virtualHosts."home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}
    '';
}
