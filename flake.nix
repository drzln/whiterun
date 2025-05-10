{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  # NOTE: we bind the whole inputs set as `inputs@{ … }`
  outputs = inputs @ {
    flake-utils,
    flake-parts,
    zig2nix,
    ...
  }:
  # and pass it straight through to mkFlake
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        zigEnv = zig2nix."zig-env".${system}; # per-system helper
        whiterun = zigEnv.package {src = ./.;}; # builds via zig build
      in {
        packages = {
          whiterun = whiterun;
          default = whiterun; # nix build .   /   nix run .
        };

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        devShells.default = zigEnv.mkShell {}; # nix develop
      };
    };
}
