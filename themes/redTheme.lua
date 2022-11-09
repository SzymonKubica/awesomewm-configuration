---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")

local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

local themeRed = "#af0000"
local themeDark = "#090909"
local minimizeDark = "#444444"
local intermediateDark = "#191919"

theme.font          = "sans 8"

theme.bg_normal     = "#181818"
theme.bg_focus      = themeRed
theme.bg_urgent     = "#00ff00"
theme.bg_minimize   = intermediateDark
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#dadada"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = minimizeDark

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(1)
theme.border_normal = themeDark
theme.border_focus  = themeRed
theme.border_marked = "#91231c"

theme.taglist_bg_focus = themeRed
theme.taglist_bg_occupied = minimizeDark
theme.tasklist_bg_focus = themeDark
theme.tasklist_fg_focus = theme.fg_focus

theme.tasklist_shape_border_color_focus = themeRed
theme.tasklist_shape_border_color = minimizeDark
theme.tasklist_shape_border_width_focus = 3
theme.tooltip_border_color = themeRed

theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_modifiers_fg = minimizeDark
theme.hotkeys_border_color = themeRed
theme.hotkeys_shape = function(cr, w, h)
                        gears.shape.rounded_rect(cr, w, h, 25)
                      end

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Make the entries in the tasklist simple
theme.tasklist_plain_task_name = true
theme.tasklist_disable_task_name = true

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_border_color = themeRed
theme.notification_shape = function(cr, w, h)
                        gears.shape.rounded_rect(cr, w, h, 25)
                      end

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define wallpaper location
theme.wallpaper = "~/.config/awesome/themes/hexagons.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
