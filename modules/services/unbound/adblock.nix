{
    fetchurl,
    pkgs,
    stdenvNoCC,
    ...
}:
stdenvNoCC.mkDerivation rec {
    name = "adblock";
    version = "3.16.55";

    buildInputs = with pkgs; [gawk];

    src = fetchurl {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/refs/tags/${version}/alternates/fakenews/hosts";
        sha256 = "WbjxCn6JKCxiRVvzQXQ0TjKIlQ2Yyb8mkEjspSZbMQA=";
    };

    dontUnpack = true;
    buildPhase = ''
        cat $src | awk '{sub(/\r$/,"")} {sub(/^127\.0\.0\.1/,"0.0.0.0")} BEGIN { OFS = "" } NF == 2 && $1 == "0.0.0.0" { print "local-zone: \"", $2, "\" refuse"}'  | tr '[:upper:]' '[:lower:]' | sort -u > adblock
    '';

    installPhase = ''
        mv adblock $out
    '';
}
