{
  lib,
  stdenv,
  wrapNeovimUnstable,
  neovim-unwrapped,
  plugins ? [],
  extraPackages ? [],
}: let
  fs = lib.fileset;

  nvimRtp = stdenv.mkDerivation {
    name = "nvim-rtp";
    src = fs.toSource {
      root = ./..;
      fileset = fs.unions [
        ../lua
        ../plugin
        ../ftplugin
        ../ftdetect
      ];
    };
    buildPhase = ''
      mkdir -p $out/lua
      mkdir -p $out/plugin
      mkdir -p $out/ftplugin
      mkdir -p $out/ftdetect
    '';
    installPhase = ''
      cp -r lua $out/lua
      cp -r plugin $out/plugin
      cp -r ftplugin $out/ftplugin
      cp -r ftdetect $out/ftdetect
    '';
  };

  # Find nvim-treesitter plugin to add its parser directory to runtimepath
  treesitterPlugin = lib.findFirst
    (p: lib.hasInfix "nvim-treesitter" (p.outPath or p.name or ""))
    null
    plugins;

  treesitterPath = if treesitterPlugin != null
    then "vim.opt.rtp:append('${treesitterPlugin}')\n  "
    else "";

  initLua = ''
    vim.opt.rtp:prepend('${nvimRtp}/lua')
    vim.opt.rtp:prepend('${nvimRtp}/plugin')
    vim.opt.rtp:prepend('${nvimRtp}/ftplugin')
    vim.opt.rtp:prepend('${nvimRtp}/ftdetect')
    ${treesitterPath}''
  + (builtins.readFile ../init.lua);

  wrapperArgs = ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';

in 
wrapNeovimUnstable neovim-unwrapped {
  plugins = plugins;
  luaRcContent = initLua;
  wrapperArgs = wrapperArgs;
}
