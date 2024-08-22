{ buildFHSEnv, stdenv, autoPatchelfHook, makeDesktopItem, fetchurl
, copyDesktopItems, config, pkgs, ... }:

let
  defaultVersion = import ./version.nix;
  pname = "spplice";
  name = pname;
  icon = ./icon.png;

  mkSrc = versionInfo: fetchurl { inherit (versionInfo) url hash; };

  mkSpplice = versionInfo:
    stdenv.mkDerivation {
      inherit pname;
      inherit (versionInfo) version;

      src = mkSrc versionInfo;

      dontUnpack = true;

      nativeBuildInputs = [ autoPatchelfHook copyDesktopItems ];

      installPhase = ''
        mkdir -p $out/bin/${pname}
        cp $src $out/bin/${pname}/${pname}
        chmod +x $out/bin/${pname}/${pname}

        mkdir -p $out/usr/share/pixmaps
        cp ${icon} $out/usr/share/pixmaps/${pname}.png
      '';

      meta = with pkgs.lib; {
        homepage = "https://p2r3.com/spplice";
        description = "A Portal 2 mod loader";
        platforms = platforms.linux;
      };
    };

  mkDesktopItem = spplice:
    (makeDesktopItem {
      name = pname;
      desktopName = "Spplice";
      exec = "${spplice.name} %u";
      icon = "${spplice}/usr/share/pixmaps/${pname}.png";
      categories = [ "Game" ];
    });

  mkSppliceFHS = versionInfo:
    let
      spplice = mkSpplice versionInfo;
      desktopItem = mkDesktopItem spplice;
    in buildFHSEnv {
      inherit pname;
      inherit (versionInfo) version;

      targetPkgs = _: [ spplice ];

      runScript = "/bin/${pname}/${pname}";

      multiPkgs = _:
        with pkgs; [
          curl
          libarchive
          libdrm
          xorg.libSM
          xorg.libICE
          xorg.xcbutilwm
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.libxcb
          libxkbcommon
          fontconfig
          freetype
          libGL
          libxkbcommon
          dbus
          harfbuzz
          zlib
          zstd
          glib
          libgcc
        ];

      extraInstallCommands = ''
        mkdir -p "$out/share/applications"
        cp "${desktopItem}/share/applications/${pname}.desktop" "$out/share/applications/${pname}.desktop"
      '';

      meta = spplice.meta;
    };

  # Why do I gotta make my own thing? .override doesn't work!?
  makeOverridable = f: origArgs:
    let origRes = f origArgs;
    in origRes // { overrideVersion = newArgs: (f (origArgs // newArgs)); };
in makeOverridable mkSppliceFHS (import ./version.nix)
