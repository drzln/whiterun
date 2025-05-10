{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  # bind the whole inputs set and pass it to mkFlake
  outputs = inputs @ {
    self,
    flake-utils,
    flake-parts,
    zig2nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # build for the four canonical systems
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        # zig2nix helper for *this* system (it's a function, so call it)
        zigEnv = zig2nix.outputs."zig-env".${system} {};
        # build the project (auto-detects build.zig + .zon / lock)
        whiterun = zigEnv.package {src = ./.;};
      in {
        ##############################
        ## Packages and runnable app ##
        ##############################
        packages = {
          whiterun = whiterun;
          default = whiterun; # nix build .   /   nix run .
        };

        apps.run = {
          type = "app";
          program = "${whiterun}/bin/whiterun";
        };

        ##############################
        ## Development shell (direnv) ##
        ##############################
        devShells.default = zigEnv.mkShell {
          # add the built CLI to PATH inside `nix develop`
          buildInputs = [whiterun];
        };
      };
    };
}
