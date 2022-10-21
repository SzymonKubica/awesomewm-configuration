local wibox   = require("wibox")
local awful   = require("awful")
local common  = require("common")

-- Widgets
local minimiser          = require("widgets.minimiser.minimiser")
local mytextclock        = wibox.widget.textclock("%d %b %H:%M")
local language_widget    = require("widgets.keyboard-language-widget.keyboard-language-widget")
local menu_widget        = require("widgets.logout-menu-widget.logout-menu")()

local cpu_widget         = require("widgets.cpu-widget.cpu-widget")({
  width = 200, color = common.beautiful.border_focus })

local brightness_widget  = require("widgets.brightness-widget.brightness")({
  type = 'arc', program = 'brillo', step = 3, })

local battery_arc_widget = require("widgets.batteryarc-widget.batteryarc")({
  show_current_level = true, size = 40, })

local volume_widget      = require("widgets.volume-widget.volume")({
  widget_type = 'arc' })

local wibox_template = function(s)
   return awful.wibar({ position = "bottom", height = 60, screen = s })
end

local primary_right_widgets = {
  layout = wibox.layout.fixed.horizontal,
  spacing = 10,
  cpu_widget,
  wibox.widget.systray(),
  mytextclock,
  language_widget.widget,
  volume_widget,
  brightness_widget,
  battery_arc_widget,
  menu_widget,
}

local secondary_right_widgets = {
  layout = wibox.layout.fixed.horizontal,
  spacing = 10,
  cpu_widget,
  wibox.widget.systray(),
  mytextclock,
  language_widget.widget,
  volume_widget,
  battery_arc_widget,
  menu_widget,
}

local function left_widgets(s)
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,
    s.mytaglist,
    s.mypromptbox,
    minimiser,
  }
end

local function right_widgets(s)
	if s.geometry.x == 0 then
    return primary_right_widgets
  else
    return secondary_right_widgets
  end
end

local function setup_wibox(s)
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    left_widgets(s),
    s.mytasklist,
    right_widgets(s)
  }
end

return {
  wibox_template = wibox_template,
  setup_wibox = setup_wibox
}
