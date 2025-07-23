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
      ];
    };
    buildPhase = ''
      mkdir -p $out/lua
      mkdir -p $out/plugin
      mkdir -p $out/ftplugin
    '';
    installPhase = ''
      cp -r lua $out/lua
      cp -r plugin $out/plugin
      cp -r ftplugin $out/ftplugin
    '';
  };

  initLua = ''
    vim.opt.rtp:prepend('${nvimRtp}/lua')
    vim.opt.rtp:prepend('${nvimRtp}/plugin')
    vim.opt.rtp:prepend('${nvimRtp}/ftplugin')
  ''
  + (builtins.readFile ../init.lua);

  wrapperArgs = ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';

in 
wrapNeovimUnstable neovim-unwrapped {
  plugins = plugins;
  luaRcContent = initLua;
  wrapperArgs = wrapperArgs;
}
