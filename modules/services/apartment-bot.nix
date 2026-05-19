{config, ...}: {
    services.apartment-bot = {
        enable = true;
        environmentFile = "/persist/passwords/apartment-bot.env";
        settings = {
            max_rent = 850;
            warm_rent_offset = 200;
            min_size = 30;

            banned_postal_codes = [
                "10551"
                "10553"
                "10555"
                "10557"
                "10559"
                "10585"
                "10587"
                "10589"
                "10623"
                "10625"
                "10627"
                "10629"
                "10707"
                "10709"
                "10711"
                "10713"
                "10717"
                "10719"
                "10777"
                "10779"
                "10785"
                "10787"
                "10789"
                "12107"
                "12163"
                "12165"
                "12167"
                "12203"
                "12205"
                "12207"
                "12209"
                "12247"
                "12249"
                "12277"
                "12279"
                "12305"
                "12307"
                "12309"
                "12349"
                "12351"
                "12353"
                "12355"
                "12357"
                "12524"
                "12526"
                "12527"
                "12557"
                "12559"
                "12589"
                "12619"
                "12621"
                "12623"
                "12627"
                "12629"
                "12679"
                "12683"
                "12685"
                "12687"
                "12689"
                "13051"
                "13053"
                "13057"
                "13059"
                "13089"
                "13125"
                "13127"
                "13129"
                "13156"
                "13158"
                "13159"
                "13349"
                "13351"
                "13403"
                "13405"
                "13407"
                "13435"
                "13437"
                "13439"
                "13465"
                "13467"
                "13469"
                "13503"
                "13505"
                "13507"
                "13509"
                "13581"
                "13583"
                "13585"
                "13587"
                "13589"
                "13591"
                "13593"
                "13595"
                "13597"
                "13599"
                "13627"
                "13629"
                "14050"
                "14052"
                "14053"
                "14055"
                "14057"
                "14059"
                "14089"
                "14109"
                "14129"
                "14163"
                "14165"
                "14167"
                "14169"
                "14193"
                "14195"
                "14199"
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

    nixos-core.impermanence.persist.directories = [
        {
            directory = "/var/lib/apartment-bot";
            inherit (config.services.apartment-bot) user;
        }
    ];
}
