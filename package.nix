{ appimageTools, makeDesktopItem, fetchurl, copyDesktopItems, config, ... }:

let
  defaultVersion = import ./version.nix;
  cfg = config.programs.spplice or { };
  version = cfg.version or defaultVersion.version;
  url = cfg.url or defaultVersion.url;
  hash = cfg.hash or defaultVersion.hash;
in appimageTools.wrapType1 {
  name = "spplice";
  src = fetchurl { inherit url hash; };

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [
    (makeDesktopItem {
      name = "Spplice2";
      exec = "electron /opt/spplice/app.asar --disable-gpu-vsync $@";
      icon = "spplice";
      desktopName = "spplice";
      categories = [ "Games" ];
    })
  ];

  extraPkgs = pkgs: with pkgs; [ electron_30-bin ];
}
