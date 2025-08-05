{ pkgs, ... }: {

  ############################################################
  # Core
  system.stateVersion = 6;
  system.primaryUser  = "mac";
  users.users.mac.home = "/Users/mac";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;

  ############################################################
  # Hostname / Bonjour
  networking = {
    hostName      = "macbook";
    localHostName = "macbook";
    computerName  = "mac@macbook";
  };

  ############################################################
  # Homebrew apps
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
    ];
  };

  ############################################################
  # Dock reset & populate  (runs every switch)
  system.activationScripts.manageDock = {
    supportsDryRun = false;                # ensure it always executes
    text           = builtins.readFile ./dock.sh;
  };

  ############################################################
  environment.systemPackages = [ ];
}

