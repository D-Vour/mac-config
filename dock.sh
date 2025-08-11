# reset Dock exactly once
/opt/homebrew/bin/dockutil --remove all --no-restart
killall Dock
sleep 2   # give Finder time to re-insert itself

# add your tiles (paths only)
dockutil --add "/System/Applications/Launchpad.app"              --no-restart
dockutil --add "/System/Applications/Utilities/Terminal.app"     --no-restart
dockutil --add "/Applications/Brave Browser.app"                 --no-restart
dockutil --add "/Applications/ProtonVPN.app"                     --no-restart
dockutil --add "/Applications/Proton Pass.app"                   --no-restart
dockutil --add "/Applications/Proton Mail.app"                   --no-restart
dockutil --add "/Applications/UTM.app"                           --no-restart
dockutil --add "/Applications/Discord.app"                       --no-restart
killall Dock   # final refresh

