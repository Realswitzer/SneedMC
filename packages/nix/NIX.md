# How to import

To import with flakes use
```nix
inputs = {
  sneedmc.url = "github:Sneederix/SneedMC";
};

...

nixpkgs.overlays = [ inputs.sneedmc.overlay ]; ## Within configuration.nix
environment.systemPackages = with pkgs; [ sneedmc ]; ##
```

To import without flakes use channels:

```
nix-channel --add https://github.com/Sneederix/SneedMC/archive/master.tar.gz sneedmc
nix-channel --update sneedmc
nix-env -iA sneedmc
```

or alternatively you can use

```
nixpkgs.overlays = [
  (import (builtins.fetchTarball "https://github.com/Sneederix/SneedMC/archive/develop.tar.gz")).overlay
];

environment.systemPackages = with pkgs; [ sneedmc ];
```
