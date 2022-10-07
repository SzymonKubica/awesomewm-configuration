local gears         = require("gears")

local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor
local beautiful     = require("beautiful")

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/redTheme.lua")
beautiful.font = "sans 9"

return {
  terminal   = terminal,
  editor     = editor,
  editor_cmd = editor_cmd,
  beautiful  = beautiful,
}
