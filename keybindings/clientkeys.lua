local awful         = require("awful")
local gears = require("gears")

local add_keybinding = require("keybindings.common").add_keybinding
local join_group     = require("keybindings.common").join_group
local super          = require("keybindings.common").super
local control        = require("keybindings.common").control

local clientkeys = gears.table.join()

clientkeys = join_group("client", clientkeys,
  add_keybinding("toggle fullscreen")
    ({ super,           }, "f")
    (function (c)
      c.fullscreen = not c.fullscreen
      if not c.fullscreen then
         c.shape = function(cr, w, h)
           gears.shape.rounded_rect(cr, w, h, 25)
         end
       else
         c.shape = function(cr, w, h)
           gears.shape.rounded_rect(cr, w, h, 0)
         end
      end
      c:raise()
    end),

  add_keybinding("close")
    ({ control,          }, "q") (function (c) c:kill() end),

  add_keybinding("toggle floating")
    ({ control, "Mod4" }, "space") (awful.client.floating.toggle),

  add_keybinding("move to master")
    ({ control, "Mod4" }, "Return") (function (c) c:swap(awful.client.getmaster()) end),

  add_keybinding("move to screen")
    ({ control }, "o") (function (c) c:move_to_screen() end),

  add_keybinding("toggle keep on top")
    ({ super }, "t") (function (c) c.ontop = not c.ontop end),

  add_keybinding("minimize")
    ({ control }, "n") (function (c) c.minimized = true end),

  add_keybinding("(un)maximize")
    ({ control }, "m")
    (function (c)
      c.maximized = not c.maximized
      c:raise()
    end),

  add_keybinding("(un)maximize vertically")
    ({ control, "Mod4" }, "m")
    (function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end),

  add_keybinding("(un)maximize horizontally")
    ({ control, "Shift"   }, "m")
    (function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end)
)

return clientkeys
