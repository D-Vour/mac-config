{ config, pkgs, ... }: {
  system.stateVersion = 4;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    utm
    git
    vim
    dockutil
  ];

  # Reset the Dock to minimal items
  system.activationScripts.set-dock.text = ''
    echo "Resetting dock..."
    dockutil --remove all --no-restart
    dockutil --add "/System/Applications/Finder.app" --no-restart
    dockutil --add "/System/Applications/Launchpad.app" --no-restart
    dockutil --add "/System/Applications/System Settings.app" --no-restart
    dockutil --add "/Applications/Terminal.app" --no-restart
    dockutil --add "/Applications/Safari.app" --no-restart
    dockutil --add "/Applications/UTM.app"
  '';
}

