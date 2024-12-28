{
  description = "A devShell example";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    probers-21-1-0-nixpkgs.url = "github:NixOS/nixpkgs/fd04bea4cbf76f86f244b9e2549fca066db8ddff";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... } @inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        
	pkgs = import nixpkgs {
          inherit system overlays;
        };

	rustCustom = pkgs.rust-bin.stable.latest.default.override {
	    extensions = [ "rust-src" ];
	    targets = [ "thumbv7em-none-eabihf" ];
	};
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            openssl
            pkg-config
            eza
            fd
	    rustCustom
	    flip-link
	    inputs.probers-21-1-0-nixpkgs.legacyPackages.${system}.probe-rs
          ];
        };
      }
    );
}

