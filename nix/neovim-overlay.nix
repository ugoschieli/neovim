final: prev: let 
  pkgs = prev;

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
    neogit
    nvim-dap
    nvim-dap-ui
    nvim-lspconfig
    nvim-nio
    nvim-surround
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-autotag
    nvim-web-devicons
    oil-nvim
    plenary-nvim
    rainbow-delimiters-nvim
    rose-pine
    telescope-fzf-native-nvim
    telescope-nvim
    trouble-nvim
    undotree
  ];

  extraPackages = with pkgs; [
    lua-language-server
    stylua
    typescript-language-server
    vscode-langservers-extracted
    emmet-language-server
    prettierd
    dockerfile-language-server-nodejs
    docker-compose-language-service
    gopls
    haskell-language-server
    tailwindcss-language-server
    clang-tools
  ];
in {
  myneovim = pkgs.callPackage ./mkNeovim.nix {
    inherit plugins extraPackages;
  };
}
