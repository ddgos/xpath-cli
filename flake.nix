{
  description = "Evaluate xpath expressions on XML or HTML documents";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, naersk, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        naersk' = pkgs.callPackage naersk { };
        nativeBuildInputs = with pkgs; [
            libxml2
            pkg-config
        ];
    in
      rec {
        packages.default = naersk'.buildPackage {
          src = ./.;
          inherit nativeBuildInputs; 
        };

        devShell = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            rustc
            cargo
            clippy
          ];
        };
      }
    );
}
