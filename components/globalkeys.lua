local awful   = require("awful")
local gears   = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("common")

local volume_widget      = require("widgets.volume-widget.volume")
local brightness_widget  = require("widgets.brightness-widget.brightness")
local language_widget    = require("widgets.keyboard-language-widget.keyboard-language-widget")
local minimiser          = require("widgets.minimiser.minimiser")
local menu               = require("components.menu")

local xrandr = require("utilities.xrandr")

-- The primary modifier key is Control. That way there are two such keys on each
-- keyboard and hence shortcuts requiring pressing left-handed keys can be
-- triggered by pressing the left control.
local control = "Control"
-- The secondary modifier key is super. It is mainly used for actions involving
-- moving windows around.
local super = "Mod4"

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

-- The add_mapping function takes in a group and a description of a specific
-- action for which we want to create a key shortcut. Then the function returns
-- another function which accepts the combination of modifier keys and the
-- corresponding key to trigger the shortcut. Then that function returns a
-- function which takes in the actual action which we want to perform once the
-- key combination is pressed and returns the awful.key mapping.
-- The reason for that convoluted way of constructing the keybinding from
-- partial functions is to make the code for defining keybindings as concise
-- and descriptive as possible.
local function add_keybinding(description)
  return function(modifier_combination, trigger_key)
    return function(action)
      return function(group_name)
        return awful.key(
          modifier_combination,
          trigger_key,
          action,
          build_label(description, group_name))
      end
    end
  end
end

local globalkeys = gears.table.join()

local function create_group(group_name, ...)
  for _, binding in pairs({...}) do
    gears.table.join(globalkeys, binding(group_name))
  end
end

create_group("awesome",
  add_keybinding("Toggle picom on/off")
    ({}, "XF86Favorites") (togglePicom),

  add_keybinding("Toggle picom on/off")
    ({control, "Shift"}, "d") (togglePicom),

  add_keybinding("show main menu")
    ({ super,           }, "w")
    (function () menu:show() end),

  add_keybinding("lock")
    ({ super }, "Escape")
    (function() awful.spawn.with_shell("bash ~/.local/bin/lock") end)
)

create_group("media",
  add_keybinding("Change screen layout")
    ({ control, super }, "d") (xrandr.xrandr),

  add_keybinding("Change screen layout")
    ({}, "XF86Display") (xrandr.xrandr),

  add_keybinding("Play/Pause music")
    ({}, "XF86AudioPlay") (toggle_play_pause),

  add_keybinding("Play next track")
    ({}, "XF86AudioNext") (function() awful.spawn.with_shell("mpc next") end),

  add_keybinding("Play previous track")
    ({}, "XF86AudioPrev") (function() awful.spawn.with_shell("mpc prev") end),

  add_keybinding("Increase volume")
    ({}, "XF86AudioRaiseVolume") (function() volume_widget:inc(5) end),

  add_keybinding("Decrease volume")
    ({}, "XF86AudioLowerVolume") (function() volume_widget:dec(5) end),

  add_keybinding("Toggle mute")
    ({}, "XF86AudioMute") (function () volume_widget:toggle() end),

  add_keybinding("Toggle mic mute")
    ({}, "XF86AudioMicMute") (function() os.execute("pactl set-source-mute 5 toggle") end),

  add_keybinding("Increase brightness")
    ({}, "XF86MonBrightnessUp") (function () brightness_widget:inc() end),

  add_keybinding("Increase brightness")
    ({control, super}, "i") (function () brightness_widget:inc() end),

  add_keybinding("Decrease brightness")
    ({control, super}, "u") (function () brightness_widget:dec() end),

  add_keybinding("Decrease brightness")
    ({}, "XF86MonBrightnessDown") (function () brightness_widget:dec() end)
  )

create_group("screenshot",
  add_keybinding("Take a screenshot of entire screen")
    ({ control, }, "Print") (function() awful.spawn.with_shell("gscreenshot -f ~/Screenshots") end),

  add_keybinding("Take a screenshot of selection")
    ({ }, "Print") (function() awful.spawn.with_shell("gscreenshot -s -c") end),

  add_keybinding("Take a screenshot of selection and save")
    ({ control, super }, "Print") (function() awful.spawn.with_shell("gscreenshot -s -c") end)
)

create_group("input",
  add_keybinding("Change keyboard layout")
    ({ super }, "space") (language_widget.switch)
)


create_group("tag",
  add_keybinding("view previous")
    ({ control }, "Left")   (awful.tag.viewprev),


  add_keybinding("view next")
    ({ control }, "Right")  (awful.tag.viewnext),


  add_keybinding("go back")
    ({ control }, "Escape") (awful.tag.history.restore)
)

create_group("client",
  -- Vim-like configuration for client focus
  add_keybinding("focus client below")
    ({ control }, "j")
    (function () awful.client.focus.global_bydirection("down") end),

  add_keybinding("focus client above")
    ({ control }, "k")
    (function () awful.client.focus.global_bydirection("up") end),

  add_keybinding("focus client to the left")
    ({ control }, "h")
    (function () awful.client.focus.global_bydirection("left") end),

  add_keybinding("focus client to the right")
    ({ control }, "l")
    (function () awful.client.focus.global_bydirection("right") end)
)


globalkeys = gears.table.join(
    -- Layout manipulation
		awful.key({ control, "Shift"}, "h", function ()
			awful.client.swap.global_bydirection("left")
		end,
		{description = "swap with left client", group = "client"}),

		awful.key({ control, "Shift"}, "l", function ()
			awful.client.swap.global_bydirection("right")
		end,
		{description = "swap with right client", group = "client"}),

		awful.key({ control, "Shift"}, "k", function ()
			awful.client.swap.global_bydirection("up")
		end,
		{description = "swap with up client", group = "client"}),

		awful.key({ control, "Shift"}, "j", function ()
			awful.client.swap.global_bydirection("down")
		end,
		{description = "swap with down client", group = "client"}),

    awful.key({ control, "Mod4" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ control, "Mod4" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ control, "Shift" }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ super,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ control,           }, "Return", function () awful.spawn(common.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ control, "Mod4" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ control, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ super,  }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ super,  }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ super, "Shift"   }, "l",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ super, "Shift"   }, "h",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ control, "Mod4" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ control, "Mod4" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ super, "Shift"           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ control, "Mod4" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal("request::activate", "key.unminimize", {raise = true})
                  end
              end,
              {description = "restore minimized", group = "client"}),
		awful.key({ control, "Shift" }, "n",
              function ()
								minimiser:toggle()
              end,
              {description = "Toggle maximise/minimise all active clients", group = "client"}),


    -- Prompt
    awful.key({ control },            "space",     function ()
			-- Run dmenu instead of the default run prompt
			awful.util.spawn("dmenu_run -b -q -nb '#181818' -sb '#af0000' -sf '#181818' -h 60 -fn 'JetBrains Mono Nerd Font-10'") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ super }, "x",
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
    awful.key({ control }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)
-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ control }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ control, "Mod4" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ control, "Shift" }, "#" .. i + 9,
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
        awful.key({ control, "Mod4", "Shift" }, "#" .. i + 9,
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
