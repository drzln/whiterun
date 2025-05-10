{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig (Zig 0.13.0)";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  # bind whole inputs set so we can reference `inputs.nixpkgs` later
  outputs = inputs @ {
    # self,
    flake-utils,
    flake-parts,
    zig2nix,
    # nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        ####################################################################
        # 1. pick the Zig 0.13.0 compiler from zig2nix
        ####################################################################
        zigCompiler = zig2nix.packages.${system}.zig-0_13_0;

        ####################################################################
        # 2. create a zig-env for *this* system
        #    • nixpkgs  → full flake output (inputs.nixpkgs)
        #    • zig      → compiler we just picked
        ####################################################################
        zigEnv = zig2nix."zig-env".${system} {
          nixpkgs = inputs.nixpkgs; # must be the flake output, not `pkgs`
          zig = zigCompiler;
        };

        ####################################################################
        # 3. build the project (auto-detects build.zig & .zon/lock)
        ####################################################################
        whiterun = zigEnv.package {src = pkgs.lib.cleanSource ./.;};
      in {
        ###########################
        ## Packages & runnable app
        ###########################
        # packages = {
        #   whiterun = whiterun;
        #   default = whiterun; # nix build .   /   nix run .
        # };

        # apps.run = {
        #   type = "app";
        #   program = "${whiterun}/bin/whiterun";
        # };

        ###########################
        ## Dev shell (direnv / nix develop)
        ##  • brings in Zig 0.13 and the CLI
        ###########################
        devShells.default = zigEnv.mkShell {
          buildInputs = [
              whiterun
              zigCompiler
            ]; # CLI on PATH
          # zigEnv.mkShell already adds the `zig` compiler
        };
      };
    };
}
