# flake.nix
# flake.nix  —  Whiterun (Zig) + zig2nix + flake-parts
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

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        # ────────────────────────────────────────────────
        # Bring in the zig2nix helper for *this* system.
        # `zig2nix` exports it as the attribute "zig-env".
        # It returns an attr-set with .package, .mkShell, .zig, …
        # ────────────────────────────────────────────────
        zigEnv = zig2nix."zig-env" {nixpkgs = pkgs;};

        # Build the project (auto-detects build.zig & *.zon/lock).
        whiterun = zigEnv.package {
          src = ./.;
          # You can add zigBuildFlags, zigTarget, etc. here later.
        };
      in {
        ########################################
        ## Standard flake outputs for this system
        ########################################
        packages = {
          whiterun = whiterun;
          default = whiterun; # nix build .  /  nix run .
        };

        apps = {
          run = {
            type = "app";
            program = "${whiterun}/bin/whiterun";
          };
        };

        devShells.default = zigEnv.mkShell {
          # nix develop
          # add extra nativeBuildInputs / shellHook if you need them
        };
      };
    };
}
