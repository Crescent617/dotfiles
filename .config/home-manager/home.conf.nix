{ config, pkgs, fonts, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in

{
  imports = [
    ./custom/systemd.nix
    ./home.nyx.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    maple-mono.truetype # Maple Mono (Ligature TTF unhinted)
    maple-mono.NF-CN-unhinted # Maple Mono NF CN (Ligature unhinted)
  ];

  services = {
    home-manager.autoExpire = {
      enable = true;
    };
  };
}
