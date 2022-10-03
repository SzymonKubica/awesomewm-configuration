local awful = require("awful")
local gears = require("gears")

local menu  = require("components.menu")
local super = require("keybindings.common").super

local mousebuttons = gears.table.join(
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
local clientbuttons = gears.table.join(
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

return {
  mousebuttons = mousebuttons,
  clientbuttons = clientbuttons,
}
