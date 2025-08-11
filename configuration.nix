{ pkgs, ... }: {

  # Core
  system.stateVersion = 6;
  system.primaryUser  = "mac";
  users.users.mac.home = "/Users/mac";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;

  networking = {
    hostName      = "macbook";
    localHostName = "macbook";
    computerName  = "mac@macbook";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    tree
  ];


  homebrew = {
    enable          = true;
    global.brewfile = true;
    brews           = [ "dockutil" ];
    casks           = [
      "brave-browser"
      "protonvpn"
      "proton-pass"
      "proton-mail"
      "utm"
      "discord"
    ];
  };

  system.activationScripts.manageDock = {
    supportsDryRun = false;
    text           = builtins.readFile ./dock.sh;
  };

  environment.systemPackages = [ ];
}

