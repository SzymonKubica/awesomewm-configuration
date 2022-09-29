local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("common")

local awesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", common.terminal .. " -e man awesome" },
  { "edit config", common.editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

local mainmenu = awful.menu({items = {
  { "awesome", awesomemenu, common.beautiful.awesome_icon },
  { "open terminal", common.terminal }
}})

return mainmenu
