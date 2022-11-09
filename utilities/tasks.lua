local awful         = require("awful")

local function launch_apps()
  awful.spawn.with_shell("google-chrome-stable --new-window https://tasksboard.com/app")
end

return launch_apps
