{ pkgs, ... }: {

  # Ensure Hammerspoon is installed
  homebrew.casks = [ "hammerspoon" ];

  # Autostart Hammerspoon
  launchd.user.agents.hammerspoon = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-gja" "Hammerspoon" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  # Declarative Hammerspoon config
  system.activationScripts.hammerspoonConfig = {
    supportsDryRun = false;
    text = ''
      set -e
      USER_HOME="/Users/mac"
      CONF_DIR="$USER_HOME/.hammerspoon"
      CONF_FILE="$CONF_DIR/init.lua"

      mkdir -p "$CONF_DIR"
      cat > "$CONF_FILE" <<'LUA'
      -- ==== Global Mic Toggle with Leader (Shift+Space then m) ====

      local function toggleMic()
        local dev = hs.audiodevice.defaultInputDevice()
        if not dev then
          hs.alert.show("No input device")
          return
        end
        local nowMuted = dev:inputMuted()
        dev:setInputMuted(not nowMuted)
        if not nowMuted then
          hs.alert.show("Mic: MUTED")
        else
          hs.alert.show("Mic: UNMUTED")
        end
      end

      local leader = hs.hotkey.modal.new()
      local exitTimer = nil
      local timeoutSeconds = 1.2

      local function exitLeader()
        if exitTimer then exitTimer:stop() end
        leader:exit()
      end

      hs.hotkey.bind({"shift"}, "space",
        function()
          if exitTimer then exitTimer:stop() end
          leader:enter()
          hs.alert.closeAll()
          hs.alert.show("Leader", 0.5)
          exitTimer = hs.timer.doAfter(timeoutSeconds, exitLeader)
        end,
        nil,
        nil
      )

      leader:bind({}, "m", function()
        toggleMic()
        exitLeader()
      end)

      leader:bind({}, "escape", function() exitLeader() end)
      LUA

      chown mac:staff "$CONF_DIR" "$CONF_FILE"
      chmod 700 "$CONF_DIR"
      chmod 600 "$CONF_FILE"
    '';
  };
}

