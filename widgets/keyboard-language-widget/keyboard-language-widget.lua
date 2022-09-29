local wibox         = require("wibox")
local awful         = require("awful")

local language_widget = {}

language_widget.cmd = "setxkbmap"
language_widget.layout = { { "us", "" }, { "pl", "" } }
language_widget.current = 1
language_widget.widget = wibox.widget.textbox()
language_widget.widget.font =  "JetBrains Mono Nerd Font 10"
language_widget.widget:set_text(" " .. language_widget.layout[language_widget.current][1] .. " ")
language_widget.switch = function ()
		language_widget.current = language_widget.current % #(language_widget.layout) + 1
		local t = language_widget.layout[language_widget.current]
		language_widget.widget:set_text(" " .. t[1] .. " ")
		os.execute( language_widget.cmd .. " " .. t[1] .. " " .. t[2] )
end

-- Mouse bindings
language_widget.widget:buttons(
awful.util.table.join(awful.button({ }, 1, function () language_widget.switch() end))
)

return language_widget
