local gears   = require("gears")
local awful   = require("awful")
local wibox   = require("wibox")

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
                          if c == client.focus then
                              c.minimized = true
                          else
                              c:emit_signal(
                                  "request::activate",
                                  "tasklist",
                                  {raise = true}
                              )
                          end
                      end),
  awful.button({ }, 3, function()
                          awful.menu.client_list({ theme = { width = 250 } })
                      end),
  awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)


local tasklist = function(s)
  return awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
      shape_border_width = 1,
      shape  = gears.shape.rounded_bar,
    },
    layout   = {
      spacing = 20,
      layout  = wibox.layout.fixed.horizontal
    },
  }
end

return tasklist
