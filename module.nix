{ inputs, system, ... }:

{ lib, config, ... }:

with lib;

let
  cfg = config.programs.awsvpnclient;
  defaultVersion = import ./version.nix;
in {
  options.programs.awsvpnclient = {
    enable = mkEnableOption "Enable Spplice";
    # Once it's open sourced, we can download previous versions.
    # version = mkOption {
    #   type = types.str;
    #   default = defaultVersion.version;
    #   description = "Version of the Spplice to build/install";
    # };
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
