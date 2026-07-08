{ wgsl-analyzer-src, tiny-code-action-src }:
final: prev: let
  pkgs = prev;
  vim = pkgs.vimPlugins;

  # Build wgsl-analyzer from the latest upstream git (pinned in flake.lock via
  # the wgsl-analyzer-src input) instead of the nixpkgs release. Upstream's MSRV
  # is newer than nixpkgs' rustc, so build with a toolchain from rust-overlay.
  rustToolchain = pkgs.rust-bin.stable.latest.minimal;
  wgsl-analyzer-git = (pkgs.wgsl-analyzer.override {
    rustPlatform = pkgs.makeRustPlatform {
      cargo = rustToolchain;
      rustc = rustToolchain;
    };
  }).overrideAttrs (old: {
    version = "git-${wgsl-analyzer-src.shortRev or "dirty"}";
    src = wgsl-analyzer-src;
    # Vendor deps via nix's native fetchers (importCargoLock) instead of
    # fetchCargoVendor; the latter sends a python-requests User-Agent that
    # crates.io's WAF can reject. git deps need explicit outputHashes.
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${wgsl-analyzer-src}/Cargo.lock";
      outputHashes = {
        "naga-29.0.0" = "sha256-UJEXOzKVE66zRj0kKmweW5Xz3CmAMve8UwGSu4UO15U=";
        "paths-0.0.0" = "sha256-aEIdkqB8gtQZtEbogdUb5iyfcZpKIlD3FkG8ANu73/I=";
        "query-group-macro-0.0.0" = "sha256-aEIdkqB8gtQZtEbogdUb5iyfcZpKIlD3FkG8ANu73/I=";
        "stdx-0.0.0" = "sha256-aEIdkqB8gtQZtEbogdUb5iyfcZpKIlD3FkG8ANu73/I=";
        "vfs-0.0.0" = "sha256-aEIdkqB8gtQZtEbogdUb5iyfcZpKIlD3FkG8ANu73/I=";
        "vfs-notify-0.0.0" = "sha256-aEIdkqB8gtQZtEbogdUb5iyfcZpKIlD3FkG8ANu73/I=";
      };
    };
    doCheck = false;
  });

  obsidian = vim.obsidian-nvim.overrideAttrs {
    # dependencies = [ vim.telescope-nvim ];
    nvimSkipModules = [ "obsidian.pickers._fzf" "minimal" ];
  };

  # wesl treesitter parser + queries, laid out the way neovim expects on the
  # runtimepath (parser/<lang>.so and queries/<lang>/*.scm). nvim-treesitter's
  # withAllGrammars does not bundle wesl, but nixpkgs packages the grammar.
  wesl-treesitter = pkgs.runCommand "nvim-treesitter-wesl" {} ''
    mkdir -p $out/parser $out/queries/wesl
    cp ${pkgs.tree-sitter-grammars.tree-sitter-wesl}/parser $out/parser/wesl.so
    cp ${pkgs.tree-sitter-grammars.tree-sitter-wesl}/queries/*.scm $out/queries/wesl/
  '';

  tiny-code-action = (pkgs.vimUtils.buildVimPlugin {
    name = "tiny-code-action-nvim";
    src = tiny-code-action-src;
  }).overrideAttrs {
    nvimSkipModules = [ "tiny-code-action.previewers.snacks" ];
  };

  plugins = with pkgs.vimPlugins; [
    blink-cmp
    conform-nvim
    diffview-nvim
    fidget-nvim
    gitsigns-nvim
    helpview-nvim
    hex-nvim
    lazydev-nvim
    lualine-nvim
    luvit-meta
    markview-nvim
    mini-nvim
    neogit
    nvim-dap
    nvim-dap-ui
    nvim-lspconfig
    nvim-lint
    nvim-nio
    nvim-surround
    nvim-treesitter.withAllGrammars
    # nvim-treesitter-textobjects
    nvim-ts-autotag
    nvim-web-devicons
    oil-nvim
    plenary-nvim
    rainbow-delimiters-nvim
    rose-pine
    telescope-fzf-native-nvim
    telescope-nvim
    tiny-code-action
    trouble-nvim
    undotree
    wesl-treesitter

  ];

  extraPackages = with pkgs; [
    lua-language-server
    stylua
    typescript-language-server
    vscode-langservers-extracted
    emmet-language-server
    biome
    prettierd
    dockerfile-language-server-nodejs
    docker-compose-language-service
    gopls
    haskell-language-server
    tailwindcss-language-server
    clang-tools
    lldb
    wgsl-analyzer-git
  ];
in {
  myneovim = pkgs.callPackage ./mkNeovim.nix {
    inherit plugins extraPackages;
  };
}
