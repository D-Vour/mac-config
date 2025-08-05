{ config, pkgs, ... }: {
  home.stateVersion = "23.11";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    htop
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

