{
  description = "ELINA";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (sys:
    let overlay = self: super: {
            apron = self.callPackage ./apron.nix {};
            elina = self.callPackage ./elina.nix {};
        };
        pkgs = import nixpkgs {
          system = sys;
          overlays = [ overlay ];
        };
    in {
      packages = rec {
        apron = pkgs.apron;
        elina = pkgs.elina;
        numerical-analysis-libraries = pkgs.buildEnv {
          name = "numerical-analysis-libraries";
          paths = [
            apron
            elina
          ];
        };
      };
    });
}
