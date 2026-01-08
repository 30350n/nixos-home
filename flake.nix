{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-core = {
            url = "github:30350n/nixos-core";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        nixos-core,
        disko,
        ...
    } @ flake-inputs: {
        nixosConfigurations.default = self.nixosConfigurations.nixos-cloud;
        nixosConfigurations.nixos-cloud = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit flake-inputs;
                inherit (nixos-core) lib;
            };
            modules = [
                nixos-core.nixosModules.nixos-core
                disko.nixosModules.disko
                ./host
                ./modules
            ];
        };
    };
}
