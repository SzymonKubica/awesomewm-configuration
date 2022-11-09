local awful         = require("awful")

local function launch_apps()
  awful.spawn.with_shell("google-chrome-stable --new-window https://learngerman.dw.com/de/langsam-gesprochene-nachrichten/s-60040332")
  awful.spawn.with_shell("google-chrome-stable --new-window https://de.pons.com/%C3%BCbersetzung/deutsch-englisch/")
  awful.spawn.with_shell("anki")
end

return launch_apps
