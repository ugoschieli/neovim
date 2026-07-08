{
  description = "My neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wgsl-analyzer-src = {
      url = "github:wgsl-analyzer/wgsl-analyzer";
      flake = false;
    };
    tiny-code-action-src = {
      url = "github:rachartier/tiny-code-action.nvim";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, neovim, wgsl-analyzer-src, tiny-code-action-src, rust-overlay }: let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    myNeovim = import ./nix/neovim-overlay.nix { inherit wgsl-analyzer-src tiny-code-action-src; };

    forAllSystems = function:
      nixpkgs.lib.genAttrs systems (system:
        function (import nixpkgs {
          inherit system;
          overlays = [neovim.overlays.default rust-overlay.overlays.default myNeovim];
        }));
          
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.myneovim;
    });
  };
}
