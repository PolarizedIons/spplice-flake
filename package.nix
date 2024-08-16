{ appimageTools, makeDesktopItem, fetchurl, copyDesktopItems, config, pkgs, ...
}:

let
  defaultVersion = import ./version.nix;
  pname = "spplice";
  name = pname;

  cfg = config.programs.spplice or { };
  version = cfg.version or defaultVersion.version;
  url = cfg.url or defaultVersion.url;
  hash = cfg.hash or defaultVersion.hash;

  src = fetchurl { inherit url hash; };

  appimageContents = (appimageTools.extract { inherit pname version src; });
in appimageTools.wrapType1 {
  inherit pname version src;

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

  extraInstallCommands = ''
    # Add desktop convencience stuff
    install -Dm444 ${appimageContents}/spplice.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/spplice.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/spplice.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname}"
  '';

  extraPkgs = pkgs: with pkgs; [ electron_30-bin ];

  meta = with pkgs.lib; {
    homepage = "https://p2r3.com/spplice";
    description = "A Portal 2 mod loader";
    platforms = platforms.linux;
  };
}
