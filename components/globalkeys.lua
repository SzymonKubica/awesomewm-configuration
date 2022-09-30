local awful   = require("awful")
local gears   = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("common")

local volume_widget      = require("widgets.volume-widget.volume")
local brightness_widget  = require("widgets.brightness-widget.brightness")
local language_widget    = require("widgets.keyboard-language-widget.keyboard-language-widget")
local minimiser          = require("widgets.minimiser.minimiser")

local xrandr = require("utilities.xrandr")

-- That way keybindings on the left can be accessed using the right ctrl
modkey = "Control"
-- The second modkey2 is the super key.
modkey2 = "Mod4"
-- Toggle switch to turn picom on/off

local isPicomOn = true

local togglePicom = function ()
	if isPicomOn then
		awful.spawn.with_shell("pkill picom")
		isPicomOn = false
	else
		awful.spawn.with_shell("picom --experimental-backends")
		isPicomOn = true
	end
end


-- Toggle play/pause
local isMusicPlaying = true

local toggle_play_pause = function ()
	if isMusicPlaying then
		awful.spawn.with_shell("mpc pause")
		isMusicPlaying = false
	else
		awful.spawn.with_shell("mpc play")
		isMusicPlaying = true
	end
end

local function build_label(description, group)
  return {
    description = description,
    group = group,
  }
end

local function add_mapping_to_group(group, description)
  return function(modifier_combination, trigger_key)
    return function(action)
      return awful.key(
        modifier_combination,
        trigger_key,
        action,
        build_label(description, group))
    end
  end
end

local globalkeys = gears.table.join(
    add_mapping_to_group("awesome", "Toggle picom on/off")
      ({}, "XF86Favorites") (togglePicom),

    add_mapping_to_group("awesome", "Toggle picom on/off")
		  ({modkey, "Shift"}, "d") (togglePicom),

    add_mapping_to_group("media", "Change screen layout")
		  ({ modkey, modkey2 }, "d") (xrandr.xrandr),

    add_mapping_to_group("media", "Change screen layout")
		  ({}, "XF86Display") (xrandr.xrandr),

    add_mapping_to_group("media", "Play/Pause music")
		  ({}, "XF86AudioPlay") (toggle_play_pause),

    add_mapping_to_group("media", "Play next track")
		  ({}, "XF86AudioNext") (function() awful.spawn.with_shell("mpc next") end),

    add_mapping_to_group("media", "Play previous track")
		  ({}, "XF86AudioPrev") (function() awful.spawn.with_shell("mpc prev") end),

    add_mapping_to_group("media", "Increase volume")
		  ({}, "XF86AudioRaiseVolume") (function() volume_widget:inc(5) end),

    add_mapping_to_group("media", "Decrease volume")
		  ({}, "XF86AudioLowerVolume") (function() volume_widget:dec(5) end),

    add_mapping_to_group("media", "Toggle mute")
		  ({}, "XF86AudioMute") (function () volume_widget:toggle() end),

    add_mapping_to_group("media", "Toggle mic mute")
		  ({}, "XF86AudioMicMute") (function() os.execute("pactl set-source-mute 5 toggle") end),

    add_mapping_to_group("media", "Increase brightness")
		  ({}, "XF86MonBrightnessUp") (function () brightness_widget:inc() end),

    add_mapping_to_group("media", "Increase brightness")
		  ({modkey, modkey2}, "i") (function () brightness_widget:inc() end),


	  add_mapping_to_group("media", "Decrease brightness")
		  ({modkey, modkey2}, "u") (function () brightness_widget:dec() end),


    add_mapping_to_group("media", "Decrease brightness")
		  ({}, "XF86MonBrightnessDown") (function () brightness_widget:dec() end),


	  add_mapping_to_group("screenshot", "Take a screenshot of entire screen")
		  ({ modkey, }, "Print") (function() awful.spawn.with_shell("gscreenshot -f ~/Screenshots") end),


	  add_mapping_to_group("screenshot", "Take a screenshot of selection")
		  ({ }, "Print") (function() awful.spawn.with_shell("gscreenshot -s -c") end),


	  add_mapping_to_group("screenshot", "Take a screenshot of selection and save")
		  ({ modkey, modkey2 }, "Print") (function() awful.spawn.with_shell("gscreenshot -s -c") end),


    add_mapping_to_group("input", "Change keyboard layout")
      ({ modkey2 }, "space") (language_widget.switch),


    add_mapping_to_group("awesome", "show help")
      ({ modkey }, "s")      (hotkeys_popup.show_help),


    add_mapping_to_group("tag", "view previous")
      ({ modkey }, "Left")   (awful.tag.viewprev),


    add_mapping_to_group("tag", "view next")
      ({ modkey }, "Right")  (awful.tag.viewnext),


    add_mapping_to_group("tag", "go back")
      ({ modkey }, "Escape") (awful.tag.history.restore),


    add_mapping_to_group("awesome", "lock")
      ({ modkey2 }, "Escape") (function() awful.spawn.with_shell("bash ~/.local/bin/lock") end),

-- add_mappingVim-like configuration for client focus
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
-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Mod4" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Mod4", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

return globalkeys
