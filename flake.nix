{
  description = "🏰 Whiterun — Declarative KVM-VM launcher in Zig";

  inputs = {
    nixpkgs     .url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils .url = "github:numtide/flake-utils";
    flake-parts .url = "github:hercules-ci/flake-parts";
    zig2nix     .url = "github:Cloudef/zig2nix";
  };

  outputs = {
    flake-utils,
    flake-parts,
    zig2nix,
    ...
  }:
    flake-parts.lib.mkFlake {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        system,
        # pkgs,
        ...
      }: let
        # ←── pick the helper for THIS system (no function call)
        zigEnv = zig2nix."zig-env".${system};

        # build the project (auto-detects build.zig + *.zon/lock)
        whiterun = zigEnv.package {src = ./.;};
      in {
        ########################################
        ## Standard flake outputs for this system
        ########################################
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
