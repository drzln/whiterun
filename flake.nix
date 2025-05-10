{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  outputs = inputs @ {
    self,
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
        # ── zig2nix helper (pin Zig 0.13.0) ──────────────────────────
        zigEnv = zig2nix.outputs."zig-env".${system} {
          nixpkgs = pkgs; # correct parameter name
          zig = pkgs.zig_0_13; # compiler version to use
        };

        whiterun = zigEnv.package {src = ./.;};
      in {
        # ── packages & runnable app ──────────────────────────────────
        packages = {
          whiterun = whiterun;
          default = whiterun;
        };

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        # ── dev shell with Zig 0.13 + CLI on PATH ───────────────────
        devShells.default = zigEnv.mkShell {
          buildInputs = [whiterun];
        };
      };
    };
}
