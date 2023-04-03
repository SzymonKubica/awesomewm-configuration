-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- AwesomeWM libraries
local awful   = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")

require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Common global definitions
local common = require("common")

-- Core Components
local tasklist       = require("components.tasklist")
local taglist        = require("components.taglist")
local wibox_template = require("components.custom_wibox").wibox_template
local setup_wibox    = require("components.custom_wibox").setup_wibox

-- Utilities
local autostart     = require("utilities.autostart")
local set_wallpaper = require("utilities.theming").set_wallpaper
local round_corners = require("utilities.theming").round_corners

-- Keybindings
local globalkeys    = require("keybindings.globalkeys")
local clientkeys    = require("keybindings.clientkeys")
local mousebuttons  = require("keybindings.mousebindings").mousebuttons
local clientbuttons = require("keybindings.mousebindings").clientbuttons

-- Set global keybindings.
root.buttons(mousebuttons)
root.keys(globalkeys)

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error",
    function (err)
      -- Make sure we don't go into an endless error loop
      if in_error then return end
      in_error = true

      naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err)
      })

      in_error = false
    end)
end

-- }}}


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.spiral.dwindle,
}

-- Set the terminal for applications that require it
menubar.utils.terminal = common.terminal

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- When setting up external 1080p display, change the dpi accordingly.
  -- Doesn't affect the apps.
  --if s.geometry.height == 1080  then
   -- s.dpi= 81
  --end

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  s.mytaglist  = taglist(s)
  s.mytasklist = tasklist(s)

  -- Create the wibox
  s.mywibox = wibox_template(s)
  setup_wibox(s)
end)


-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = common.beautiful.border_width,
        border_color = common.beautiful.border_normal,
        focus        = awful.client.focus.filter,
        raise        = true,
        keys         = clientkeys,
        buttons      = clientbuttons,
        screen       = awful.screen.preferred,
        placement    = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
					"Settings",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
      properties = { floating = true }},
}
-- }}}

-- {{{ Signals

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Signal function to execute when a new client appears.
client.connect_signal("manage",
  function (c)
    c.shape = round_corners

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
  end)

client.connect_signal("focus",
  function(c) c.border_color = common.beautiful.border_focus end)
client.connect_signal("unfocus",
  function(c) c.border_color = common.beautiful.border_normal end)

-- }}}

autostart()
