{ inputs, system, ... }:

{ lib, config, ... }:

with lib;

let
  cfg = config.programs.spplice;
  defaultVersion = import ./version.nix;
in {
  options.programs.spplice = {
    enable = mkEnableOption "Enable Spplice";
    version = mkOption {
      type = types.str;
      default = defaultVersion.version;
      description = "Version of the Spplice to install";
    };
    sha256 = mkOption {
      type = types.str;
      default = defaultVersion.sha256;
      description = "SHA256 hash of Spplice to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.self.packages.${system}.spplice ];
  };
}
