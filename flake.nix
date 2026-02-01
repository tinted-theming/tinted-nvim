{
  description = "tinted-nvim development environment flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {system, ...}: {
      imports = [];
      flake = {};
      systems = builtins.attrNames nixpkgs.legacyPackages;
      perSystem = {system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.luajit
            pkgs.luajitPackages.vusted
          ];
        };
        legacyPackages = pkgs;
      };
    });
}
