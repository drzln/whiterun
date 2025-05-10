# flake.nix
{
  description = "🏰 Whiterun — Declarative KVM VM launcher in Zig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    # self,
    # nixpkgs,
    flake-utils,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        pkgs,
        # system,
        ...
      }: {
        # packages.whiterun = pkgs.stdenv.mkDerivation {
        #   pname = "whiterun";
        #   version = "0.1.0";
        #
        #   src = ./.;
        #
        #   nativeBuildInputs = [pkgs.zig];
        #
        #   buildPhase = ''
        #     zig build -Doptimize=ReleaseSafe
        #   '';
        #
        #   installPhase = ''
        #     mkdir -p $out/bin
        #     cp zig-out/bin/whiterun $out/bin/
        #   '';
        # };

        # defaultPackage = self.packages.${system}.whiterun;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.zig
          ];
        };
      };
    };
}
