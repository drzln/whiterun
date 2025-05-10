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
        ################################################################
        ## zig2nix helper – explicitly use Zig 0.13.0 from nixpkgs
        ################################################################
        zigEnv = zig2nix.outputs."zig-env".${system} {
          pkgs = pkgs; # pass the correct nixpkgs set
          zig = pkgs.zig_0_13; # pin compiler to 0.13.0
        };

        whiterun = zigEnv.package {src = ./.;};
      in {
        ########################################
        ## Packages & runnable app
        ########################################
        packages = {
          whiterun = whiterun;
          default = whiterun; # nix build .   /   nix run .
        };

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        ########################################
        ## Dev shell with Zig 0.13 + CLI in PATH
        ########################################
        devShells.default = zigEnv.mkShell {
          buildInputs = [whiterun]; # CLI available inside nix develop
        };
      };
    };
}
