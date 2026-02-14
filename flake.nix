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
            pkgs.just
            pkgs.luajit
            pkgs.luajitPackages.vusted
            pkgs.luajitPackages.luacheck
            pkgs.stylua
            pkgs.lua-language-server
            pkgs.lemmy-help
          ];
        };
        devShells.ci = pkgs.mkShell {
          buildInputs = [
            pkgs.just
            pkgs.luajit
            pkgs.luajitPackages.vusted
            pkgs.luajitPackages.luacheck
            pkgs.stylua
            pkgs.lua-language-server
            pkgs.lemmy-help
            pkgs.neovim
          ];
        };
        legacyPackages = pkgs;
      };
    });
}
