local awful         = require("awful")

local function startup()
  awful.spawn.with_shell("compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION")
  awful.spawn.with_shell("picom -b")
  awful.spawn.with_shell("libinput-gestures-setup start")
end

return startup
