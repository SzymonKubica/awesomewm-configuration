globalkeys = gears.table.join(
		awful.key({}, "XF86Favorites", function() togglePicom() end,
        {description = "Toggle picom on/off", group = "awesome"}),
		awful.key({modkey, "Shift"}, "d", function() togglePicom() end,
        {description = "Toggle picom on/off", group = "awesome"}),
		awful.key({ modkey, modkey2 }, "d", function() xrandr.xrandr() end,
        {description = "Change screen layout", group = "media"}),
		awful.key({}, "XF86Display", function() xrandr.xrandr() end,
        {description = "Change screen layout", group = "media"}),
		awful.key({}, "XF86AudioPlay", function() togglePlayPause() end,
        {description = "Play/Pause music", group = "media"}),
		awful.key({}, "XF86AudioNext", function() awful.spawn.with_shell("mpc next") end,
        {description = "Play next track", group = "media"}),
		awful.key({}, "XF86AudioPrev", function() awful.spawn.with_shell("mpc prev") end,
        {description = "Play previous track", group = "media"}),
		awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end,
        {description = "Increase volume", group = "media"}),
		awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end,
        {description = "Decrease volume", group = "media"}),
		awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end,
        {description = "Toggle mute", group = "media"}),
		awful.key({}, "XF86AudioMicMute", function() os.execute("pactl set-source-mute 5 toggle") end,
        {description = "Toggle mic mute", group = "media"}),
		awful.key({}, "XF86MonBrightnessUp", function() brightness_widget:inc() end,
        {description = "Increase brightness", group = "media"}),
		awful.key({modkey, modkey2}, "i", function() brightness_widget:inc() end,
        {description = "Increase brightness", group = "media"}),
		awful.key({modkey, modkey2}, "u", function() brightness_widget:dec() end,
			{description = "Decrease brightness", group = "media"}),
		awful.key({}, "XF86MonBrightnessDown", function() brightness_widget:dec() end,
        {description = "Decrease brightness", group = "media"}),
		awful.key({ modkey, }, "Print", function() awful.spawn.with_shell("gscreenshot -f ~/Screenshots") end,
			{description = "Take a screenshot of entire screen", group = "screenshot"}),
		awful.key({ }, "Print", function() awful.spawn.with_shell("gscreenshot -s -c") end,
			{description = "Take a screenshot of selection", group = "screenshot"}),
		awful.key({ modkey, modkey2 }, "Print", function() awful.spawn.with_shell("gscreenshot -s -c") end,
			{description = "Take a screenshot of selection and save", group = "screenshot"}),
    awful.key({ modkey2,           }, "space",      function () language_widget.switch() end,
              {description="Change keyboard layout", group="input"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey2,           }, "Escape", function() awful.spawn.with_shell("bash ~/.local/bin/lock") end,
              {description = "lock", group = "awesome"}),

-- Vim-like configuration for client focus
     awful.key({ modkey,           }, "j",
         function ()
             awful.client.focus.global_bydirection("down")
         end,
         {description = "focus client below", group = "client"}
     ),
     awful.key({ modkey,           }, "k",
         function ()
             awful.client.focus.global_bydirection("up")
         end,
         {description = "focus client above", group = "client"}
     ),
     awful.key({ modkey,           }, "h",
         function ()
             awful.client.focus.global_bydirection("left")
         end,
         {description = "focus client to the left", group = "client"}
     ),
     awful.key({ modkey,           }, "l",
         function ()
             awful.client.focus.global_bydirection("right")
         end,
         {description = "focus client to the right", group = "client"}
     ),

     awful.key({ modkey2,           }, "w", function () menu:show() end,
               {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
		awful.key({ modkey, "Shift"}, "h", function ()
			awful.client.swap.global_bydirection("left")
		end,
		{description = "swap with left client", group = "client"}),

		awful.key({ modkey, "Shift"}, "l", function ()
			awful.client.swap.global_bydirection("right")
		end,
		{description = "swap with right client", group = "client"}),

		awful.key({ modkey, "Shift"}, "k", function ()
			awful.client.swap.global_bydirection("up")
		end,
		{description = "swap with up client", group = "client"}),

		awful.key({ modkey, "Shift"}, "j", function ()
			awful.client.swap.global_bydirection("down")
		end,
		{description = "swap with down client", group = "client"}),

    awful.key({ modkey, "Mod4" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Mod4" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey2,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(common.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Mod4" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey2,  }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey2,  }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey2, "Shift"   }, "l",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey2, "Shift"   }, "h",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Mod4" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Mod4" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey2, "Shift"           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Mod4" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal("request::activate", "key.unminimize", {raise = true})
                  end
              end,
              {description = "restore minimized", group = "client"}),
		awful.key({ modkey, "Shift" }, "n",
              function ()
								minimiser:toggle()
              end,
              {description = "Toggle maximise/minimise all active clients", group = "client"}),


    -- Prompt
    awful.key({ modkey },            "space",     function ()
			-- Run dmenu instead of the default run prompt
			awful.util.spawn("dmenu_run -b -q -nb '#181818' -sb '#af0000' -sf '#181818' -h 60 -fn 'JetBrains Mono Nerd Font-10'") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey2 }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)
