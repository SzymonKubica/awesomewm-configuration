-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- AwesomeWM libraries
local gears   = require("gears")
local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")
local menubar = require("menubar")

-- Common global definitions
local common = require("common")

require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Core Components
local menu     = require("components.menu")
local tasklist = require("components.tasklist")
local taglist = require("components.taglist")

-- Keybindings
local globalkeys = require("keybindings.globalkeys")
local clientkeys = require("keybindings.clientkeys")
local super      = require("keybindings.common").super
local control    = require("keybindings.common").control

-- Widgets
local battery_arc_widget = require("widgets.batteryarc-widget.batteryarc")
local cpu_widget         = require("widgets.cpu-widget.cpu-widget")
local volume_widget      = require("widgets.volume-widget.volume")
local brightness_widget  = require("widgets.brightness-widget.brightness")
local menu_widget        = require("widgets.logout-menu-widget.logout-menu")
local minimiser          = require("widgets.minimiser.minimiser")
local language_widget    = require("widgets.keyboard-language-widget.keyboard-language-widget")

-- Utilities
local autostart = require("utilities.autostart")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
}

-- {{{ Menu
menubar.utils.terminal = common.terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%d %b %H:%M")


local function set_wallpaper(s)
    -- Wallpaper
    if common.beautiful.wallpaper then
        local wallpaper = common.beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false, {0, 0})
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

		s.mytaglist = taglist(s)
    s.mytasklist = tasklist(s)
		local separator = wibox.widget.textbox(" ")

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", height = 60, screen = s })

    -- Add widgets to the wibox
		if s.geometry.x == 0 then
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
				expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
						separator,
						minimiser,
						separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
						separator,
						wibox.widget.systray(),
						separator,
						cpu_widget({
							width = 200,
							color = "#af0000",
						}),
						separator,
            mytextclock,
						language_widget.widget,
						separator,
						volume_widget({
							widget_type = 'arc'
						}),
						separator,
						brightness_widget({
							type = 'arc',
							program = 'brillo',
							step = 3,
						}),
						separator,
						battery_arc_widget({
							show_current_level = true,
							size = 40,
						}),
						separator,
						menu_widget(),
						separator,
        },
    }
	else
	s.mywibox:setup {
					layout = wibox.layout.align.horizontal,
					expand = "none",
					{ -- Left widgets
							layout = wibox.layout.fixed.horizontal,
							s.mytaglist,
							s.mypromptbox,
							separator,
							minimiser,
							separator,
					},
					s.mytasklist, -- Middle widget
					{ -- Right widgets
							layout = wibox.layout.fixed.horizontal,
							separator,
							wibox.widget.systray(),
							separator,
							cpu_widget({
								width = 200,
								color = "#af0000",
							}),
							separator,
							mytextclock,
							separator,
							language_widget.widget,
							separator,
							volume_widget({
								widget_type = 'arc'
							}),
							separator,
							battery_arc_widget({
								show_current_level = true,
								size = 40,
							}),
							separator,
							menu_widget(),
							separator,
					},
			}
		end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ super }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ super }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = common.beautiful.border_width,
                     border_color = common.beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
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
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
		-- {{{ Uncomment for rounded corners
	 c.shape = function(cr, w, h)
		 gears.shape.rounded_rect(cr, w, h, 25)
	 end
		-- }}}

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
client.connect_signal("focus", function(c) c.border_color = common.beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = common.beautiful.border_normal end)
-- }}}

autostart()
