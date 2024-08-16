# Spplice Flake

Packages [spplice](https://p2r3.com/spplice), the Portal 2 mod loader, into a nixos flake.

## Usage:

```nix
# Import the module, and enable the app

imports = [ inputs.spplice.nixosModules.${system}.spplice ];

programs.spplice.enable = true;
```
