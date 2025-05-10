{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig (pinned to Zig 0.13.0)";

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
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        ############################################################
        # zig2nix helper for THIS system, pinned to Zig 0.13.0
        ############################################################
        zigEnv = zig2nix."zig-env".${system} {
          nixpkgs = pkgs; # provide nixpkgs
          zig = zig2nix.packages.${system}.zig-0_13_0;
        };

        # Build the project (auto-detects build.zig + .zon/lock)
        whiterun = zigEnv.package {src = pkgs.lib.cleanSource ./.;};
      in {
        ########################
        ## Binary & default pkg
        ########################
        packages.whiterun = whiterun;
        packages.default = whiterun; # nix build .   /   nix run .

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        ########################
        ## Dev shell
        ########################
        devShells.default = pkgs.mkShell {
          buildInputs = [
            zig2nix.packages.${system}.zig-0_13_0 # Zig compiler
            whiterun # Binary on PATH
          ];
        };
      };
    };
}
