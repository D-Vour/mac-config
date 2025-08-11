{ config, pkgs, lib, ... }:

let
  user = "mac";                                   # change if needed
  home = config.users.users.${user}.home or "/Users/${user}";
in
{
  # Install Hammerspoon
  homebrew.casks = [ "hammerspoon" ];

  # Autostart Hammerspoon at login
  launchd.user.agents.hammerspoon = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-gja" "Hammerspoon" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  # Declarative Hammerspoon config
  system.activationScripts.hammerspoonLeader = {
    supportsDryRun = false;
    text = ''
      set -e
      CONF_DIR="${home}/.hammerspoon"
      CONF_FILE="${CONF_DIR}/init.lua"

      mkdir -p "$CONF_DIR"
      cat > "$CONF_FILE" <<'LUA'
      -- Leader: Shift+Space, then keys (Emacs-style for macOS)
      -- Built-ins: m = toggle mic mute

      -- Mic toggle
      local function toggleMic()
        local dev = hs.audiodevice.defaultInputDevice()
        if not dev then
          hs.alert.show("No input device"); return
        end
        local now = dev:inputMuted()
        dev:setInputMuted(not now)
        hs.alert.show(now and "Mic: UNMUTED" or "Mic: MUTED")
      end

      -- Leader modal
      local leader = hs.hotkey.modal.new()
      local exitTimer = nil
      local timeoutSeconds = 1.2
      local function exitLeader()
        if exitTimer then exitTimer:stop() end
        leader:exit()
      end

      -- Enter leader with Shift+Space
      hs.hotkey.bind({"shift"}, "space",
        function()
          if exitTimer then exitTimer:stop() end
          leader:enter()
          hs.alert.closeAll(); hs.alert.show("Leader", 0.4)
          exitTimer = hs.timer.doAfter(timeoutSeconds, exitLeader)
        end,
        nil,
        nil
      )

      -- Built-in bindings
      leader:bind({}, "m", function() toggleMic(); exitLeader() end)
      leader:bind({}, "escape", function() exitLeader() end)

      ----------------------------------------------------------------
      -- Add your own bindings here, e.g.:
      -- leader:bind({}, "b", function() hs.application.launchOrFocus("Brave Browser"); exitLeader() end)
      -- leader:bind({"shift"}, "w", function() hs.window.focusedWindow():moveOneScreenWest(); exitLeader() end)
      ----------------------------------------------------------------
      LUA

      chown ${user}:staff "$CONF_DIR" "$CONF_FILE"
      chmod 700 "$CONF_DIR"
      chmod 600 "$CONF_FILE"
    '';
  };
}

