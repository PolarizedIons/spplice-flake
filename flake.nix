{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = rec {
          default = spplice;
          spplice = pkgs.callPackage ./package.nix { };
        };

        nixosModules = rec {
          default = spplice;
          spplice = import ./module.nix { inherit inputs system; };
        };
      });
}
