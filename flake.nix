{
  description = "My neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim = { 
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, neovim }: let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    myNeovim = import ./nix/neovim-overlay.nix;

    forAllSystems = function:
      nixpkgs.lib.genAttrs systems (system:
        function (import nixpkgs {
          inherit system;
          overlays = [neovim.overlays.default myNeovim];
        }));
          
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.myneovim;
    });
  };
}
