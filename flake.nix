{
  description = "🏰 Whiterun — Declarative KVM-VM launcher (Zig 0.13.0)";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  outputs = inputs @ {
    # self,
    flake-utils,
    flake-parts,
    # nixpkgs,
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
        ############################################################
        # 1. Pick the Zig 0.13.0 compiler provided by zig2nix
        ############################################################
        zigCompiler = zig2nix.packages.${system}.zig-0_13_0;

        ############################################################
        # 2. Create a zig-env for THIS system
        ############################################################
        zigEnv = zig2nix."zig-env".${system} {
          nixpkgs = inputs.nixpkgs; # full nixpkgs flake output
          zig = zigCompiler; # pin compiler
        };

        ############################################################
        # 3. Build Whiterun (pname + version are REQUIRED)
        ############################################################
        whiterun = zigEnv.package {
          pname = "whiterun";
          version = "0.1.0";
          src = pkgs.lib.cleanSource ./.;
        };
      in {
        ########################
        ## Packages & app
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
            zigCompiler # Zig 0.13 compiler in shell
            whiterun # CLI on PATH
          ];
        };
      };
    };
}
