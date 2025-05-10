# flake.nix
{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";
  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };
  outputs = inputs @ {
    flake-utils,
    flake-parts,
    zig2nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;
      perSystem = {system, ...}: let
        zigEnv = zig2nix.outputs."zig-env".${system} {};
        whiterun = zigEnv.package {src = ./.;};
      in {
        packages = {
          whiterun = whiterun;
          default = whiterun;
        };
        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };
        devShells.default = zigEnv.mkShell {
          buildInputs = [whiterun];
        };
      };
    };
}
