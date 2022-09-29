local awful	= require("awful")
local gears	= require("gears")
local wibox	= require("wibox")

local themeRed = "#af0000"
local minimizeDark = "#444444"
-- Spacing widget which minimises and maximises all clients on current tag.
local minimiser = {
    margins = 10,
    forced_width = 40,
    shape        = gears.shape.circle,
    color = themeRed,
    valign = 'center',
    halign = 'center',
    on = true,
    widget       = wibox.widget.separator(),
}

function minimise_all_clients_on_current_tag()
  for _, c in ipairs(mouse.screen.selected_tag:clients()) do
    c.minimized = true
  end
end

function maximise_all_clients_on_current_tag()
  for _, c in ipairs(mouse.screen.selected_tag:clients()) do
    c.minimized = false
  end
end

function minimiser:toggle()
  if minimiser.on == true then
    minimise_all_clients_on_current_tag()
    minimiser.widget.color = minimizeDark
    minimiser.on = false
  else
    maximise_all_clients_on_current_tag()
    minimiser.widget.color = themeRed
    minimiser.on = true
  end
end

minimiser.widget:buttons(
  awful.util.table.join(awful.button({ }, 1, function ()
  minimiser:toggle()end))
)

return minimiser
