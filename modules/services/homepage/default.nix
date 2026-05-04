{
    config,
    lib,
    pkgs,
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
                        "Fluidd" = rec {
                            icon = "fluidd.svg";
                            href = "https://${config.services.fluidd.hostName}";
                            siteMonitor = href;
                        };
                    }
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
                    {
                        "Immich" = rec {
                            icon = "immich.svg";
                            href = "https://immich.home.internal";
                            siteMonitor = href;
                            widget = {
                                type = "immich";
                                url = href;
                                key = api-keys.immich;
                                version = 2;
                            };
                        };
                    }
                    {
                        "InvenTree" = rec {
                            icon = "inventree.svg";
                            href = "https://inventree.home.internal";
                            siteMonitor = href;
                        };
                    }
                    {
                        "Zigbee2MQTT" = rec {
                            icon = "zigbee2mqtt.svg";
                            href = "https://zigbee2mqtt.home.internal";
                            siteMonitor = href;
                        };
                    }
                ];
            }
            {
                Devices = let
                    fluiddUrl = "https://${config.services.fluidd.hostName}";
                in [
                    {
                        "Voron 2.4" = rec {
                            icon = "voron.svg";
                            href = "${fluiddUrl}/?printer=${builtins.hashString "md5" siteMonitor}";
                            siteMonitor = "${fluiddUrl}/voron";
                            widget = {
                                type = "moonraker";
                                url = siteMonitor;
                            };
                        };
                    }
                    {
                        "Artillery Genius" = rec {
                            icon = "/icons/artillery-genius.svg";
                            href = "${fluiddUrl}/?printer=${builtins.hashString "md5" siteMonitor}";
                            siteMonitor = "${fluiddUrl}/genius";
                            widget = {
                                type = "moonraker";
                                url = siteMonitor;
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
                {Devices.style = "column";}
                {Administration.style = "column";}
            ];
        };

        #package = pkgs.runCommandLocal "homepage" {} ''
        #    cp -r ${pkgs.homepage-dashboard} $out
        #    chmod +w $out/share/homepage/public
        #    cp -r ${./icons} $out/share/homepage/public/icons
        #'';
        package = pkgs.homepage-dashboard.overrideAttrs (finalAttrs: prevAttrs: {
            postInstall =
                (prevAttrs.postInstall or "")
                + ''
                    ln -s ${./icons} $out/share/homepage/public/icons
                '';
        });

        customCSS = builtins.readFile ./custom.css;
    };

    services.caddy.virtualHosts."home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}
    '';
}
