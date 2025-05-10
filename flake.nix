{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  # `inputs@{ ... }` passes *each input’s outputs* into mkFlake
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
        # zig2nix helper for THIS system; pin the compiler to 0.13.0
        zigEnv = zig2nix."zig-env".${system} {
          nixpkgs = pkgs; # supply the current nixpkgs set
          zig = pkgs.zig_0_13;
        };

        whiterun = zigEnv.package {src = ./.;};
      in {
        ################ Packages & app ################
        packages = {
          whiterun = whiterun;
          default = whiterun; # nix build . / nix run .
        };

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        ################ Dev shell #####################
        devShells.default = zigEnv.mkShell {
          buildInputs = [whiterun]; # CLI on PATH in nix develop
        };
      };
    };
}
