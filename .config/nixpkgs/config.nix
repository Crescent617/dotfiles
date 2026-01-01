{
  allowUnfree = true;

  packageOverrides = pkgs: {
    # 1. NUR (Nix User Repository)
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };

    # 2. Unstable Channel
    unstable = import
      (builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz"; })
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };

    # 4. Starsheep (使用 getFlake)
    # 注意：使用 getFlake 要求你的 nix.conf 开启了 experimental-features = nix-command flakes
    starsheep = (builtins.getFlake "github:Crescent617/starsheep").packages.${pkgs.system}.default;
  };
}
