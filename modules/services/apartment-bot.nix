{config, ...}: {
    services.apartment-bot = {
        enable = true;
        environmentFile = "/persist/passwords/apartment-bot.env";
        settings = {
            max_rent = 850;
            warm_rent_offset = 200;
            min_size = 30;

            banned_neighborhoods = [
                "Borsigwalde"
                "Buch"
                "Falkenberg"
                "Falkenhagener Feld"
                "Falkensee"
                "Gropiusstadt"
                "Hakenfelde"
                "Haselhorst"
                "Hellersdorf"
                "Karow"
                "Lankwitz"
                "Lichtenrade"
                "Lichterfelde"
                "Marzahn"
                "Schönefeld"
                "Siemensstadt"
                "Spandau"
                "Staaken"
                "Tegel"
                "Waidmannslust"
                "Wilhelmstadt"
            ];

            scan_interval = 90;
            silent_hours = [1 8];
        };
    };

    services.caddy.virtualHosts."apartment-bot.home.internal".extraConfig = ''
        reverse_proxy localhost:${toString config.services.apartment-bot.port}
    '';

    services.unbound.settings.server.local-data = [
        ''"apartment-bot.home.internal. IN A 192.168.178.2"''
    ];
}
