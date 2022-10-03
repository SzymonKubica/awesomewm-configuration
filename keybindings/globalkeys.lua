local awful         = require("awful")
local gears         = require("gears")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("common")

local volume_widget      = require("widgets.volume-widget.volume")
local brightness_widget  = require("widgets.brightness-widget.brightness")
local language_widget    = require("widgets.keyboard-language-widget.keyboard-language-widget")
local minimiser          = require("widgets.minimiser.minimiser")
local menu               = require("components.menu")

local xrandr = require("utilities.xrandr")

local add_keybinding = require("keybindings.common").add_keybinding
local join_group     = require("keybindings.common").join_group
local super          = require("keybindings.common").super
local control        = require("keybindings.common").control

local picom_toggler = require("utilities.toggle").picom_toggler
local music_toggler = require("utilities.toggle").music_toggler

local globalkeys = gears.table.join()

globalkeys = join_group("awesome", globalkeys,
  add_keybinding("show help")
    ({ super }, "s") (hotkeys_popup.show_help),

  add_keybinding("Toggle picom on/off")
    ({}, "XF86Favorites") (function() picom_toggler.toggle(picom_toggler) end),

  add_keybinding("Toggle picom on/off")
    ({control, "Shift"}, "d") (function() picom_toggler.toggle(picom_toggler) end),

  add_keybinding("show main menu")
    ({ super,           }, "w")
    (function () menu:show() end),

  add_keybinding("lock")
    ({ super }, "Escape")
    (function() awful.spawn.with_shell("bash ~/.local/bin/lock") end),

  add_keybinding("reload awesome")
    ({ control, super }, "r") (awesome.restart),

  add_keybinding("quit awesome")
    ({ control, "Shift"   }, "q") (awesome.quit),

  add_keybinding("lua execute prompt")
    ({ super }, "x")
    (function ()
        awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end)
)

globalkeys = join_group("media", globalkeys,
  add_keybinding("Change screen layout")
    ({ control, super }, "d") (xrandr.xrandr),

  add_keybinding("Change screen layout")
    ({}, "XF86Display") (xrandr.xrandr),

  add_keybinding("Play/Pause music")
    ({}, "XF86AudioPlay") (function() music_toggler.toggle(music_toggler) end),

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
    ({}, "XF86AudioMicMute")
    (function() os.execute("pactl set-source-mute 5 toggle") end),

  add_keybinding("Increase brightness")
    ({}, "XF86MonBrightnessUp") (function () brightness_widget:inc() end),

  add_keybinding("Increase brightness")
    ({control, super}, "i") (function () brightness_widget:inc() end),

  add_keybinding("Decrease brightness")
    ({control, super}, "u") (function () brightness_widget:dec() end),

  add_keybinding("Decrease brightness")
    ({}, "XF86MonBrightnessDown") (function () brightness_widget:dec() end)
  )

globalkeys = join_group("screenshot", globalkeys,
  add_keybinding("Take a screenshot of entire screen")
    ({ control, }, "Print")
    (function() awful.spawn.with_shell("gscreenshot -f ~/Screenshots") end),

  add_keybinding("Take a screenshot of selection")
    ({ }, "Print")
    (function() awful.spawn.with_shell("gscreenshot -s -c") end),

  add_keybinding("Take a screenshot of selection and save")
    ({ control, super }, "Print")
    (function() awful.spawn.with_shell("gscreenshot -s -c") end)
)

globalkeys = join_group("input", globalkeys,
  add_keybinding("Change keyboard layout")
    ({ super }, "space") (language_widget.switch)
)


globalkeys = join_group("tag", globalkeys,
  add_keybinding("view previous")
    ({ control }, "Left") (awful.tag.viewprev),

  add_keybinding("view next")
    ({ control }, "Right") (awful.tag.viewnext),

  add_keybinding("go back")
    ({ control }, "Escape") (awful.tag.history.restore)
)

globalkeys = join_group("client", globalkeys,
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
    (function () awful.client.focus.global_bydirection("right") end),

  add_keybinding("swap with left client")
    ({ control, "Shift"}, "h")
    (function () awful.client.swap.global_bydirection("left") end),

	add_keybinding("swap with right client")
		({ control, "Shift"}, "l")
    (function () awful.client.swap.global_bydirection("right") end),

  add_keybinding("swap with up client")
  ({ control, "Shift"}, "k") (function ()
    awful.client.swap.global_bydirection("up")
  end),

  add_keybinding("swap with down client")
  ({ control, "Shift"}, "j") (function ()
    awful.client.swap.global_bydirection("down")
  end),

  add_keybinding("jump to urgent client")
  ({ control, "Shift" }, "u") (awful.client.urgent.jumpto),

  add_keybinding("go back")
    ({ super }, "Tab")
    (function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

  add_keybinding("restore minimized")
    ({ control, "Mod4" }, "n")
    (function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end),

  add_keybinding("Toggle maximise/minimise all active clients")
    ({ control, "Shift" }, "n")
    (function () minimiser:toggle() end)
)

globalkeys = join_group("screen", globalkeys,
  add_keybinding("focus the next screen")
    ({ control, "Mod4" }, "j")
    (function () awful.screen.focus_relative( 1) end),

  add_keybinding("focus the previous screen")
    ({ control, "Mod4" }, "k")
    (function () awful.screen.focus_relative(-1) end)
)

globalkeys = join_group("launcher", globalkeys,
  add_keybinding("open a terminal")
    ({ control }, "Return")
    (function () awful.spawn(common.terminal) end),

  add_keybinding("run prompt")
    ({ control }, "space")
    (function ()
			awful.util.spawn("dmenu_run -b -q -nb '#181818' -sb '#af0000' -sf '#181818' -h 60 -fn 'JetBrains Mono Nerd Font-10'")
    end),

  add_keybinding("show the menubar")
    ({ control }, "p") (function() menubar.show() end)
)

globalkeys = join_group("layout", globalkeys,
  add_keybinding("increase master width factor")
    ({ super,  }, "l") (function () awful.tag.incmwfact( 0.05) end),

  add_keybinding("decrease master width factor")
    ({ super,  }, "h") (function () awful.tag.incmwfact(-0.05) end),

  add_keybinding("increase the number of master clients")
    ({ super, "Shift"   }, "l")
    (function () awful.tag.incnmaster( 1, nil, true) end),

  add_keybinding("decrease the number of master clients")
    ({ super, "Shift"   }, "h")
    (function () awful.tag.incnmaster(-1, nil, true) end),

  add_keybinding("increase the number of columns")
    ({ control, super }, "h")
    (function () awful.tag.incncol( 1, nil, true) end),

  add_keybinding("decrease the number of columns")
    ({ control, super }, "l")
    (function () awful.tag.incncol(-1, nil, true) end),

  add_keybinding("select next")
    ({ super, "Shift" }, "space")
    (function () awful.layout.inc( 1) end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    add_keybinding("view tag #" .. i)
      ({ control }, "#" .. i + 9)
      (function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end)
      ({group = "tag" }),

    add_keybinding("toggle tag #" .. i)
      ({ control, super }, "#" .. i + 9)
      (function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end)
      ({group = "tag" }),

    add_keybinding("move focused client to tag #" .. i)
      ({ control, "Shift" }, "#" .. i + 9)
      (function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end)
      ({group = "tag" }),

    add_keybinding("toggle focused client on tag #" .. i)
      ({ control, "Mod4", "Shift" }, "#" .. i + 9)
      (function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end)
      ({group = "tag" })
  )
end

return globalkeys
