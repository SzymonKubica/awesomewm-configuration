local awful = require("awful")

local common = require("common")

local normal_background   = common.beautiful.bg_normal
local selected_background = common.beautiful.bg_focus
local selected_foreground = common.beautiful.bg_normal

local font = "JetBrains Mono Nerd Font-10"

local dmenu_command = "dmenu_run -b -q -nb '" .. normal_background .. "' -sb '" .. selected_background .. "' -sf '" .. selected_foreground .. " ' -h 60 -fn '" .. font .. "'"

local function run()
  awful.util.spawn(dmenu_command)
end

return { run = run }

