local awful         = require("awful")

ToggleSwitch = {
  is_toggled = false,
  handle_on  = function () end,
  handle_off = function () end
}
function ToggleSwitch.toggle(self)
  if self.is_toggled then
    self.handle_off()
    self.is_toggled = false
  else
    self.handle_on()
    self.is_toggled = true
  end
end

local picom_toggler = {
  is_toggled = true,
  handle_on  = function () awful.spawn.with_shell("picom --experimental-backends") end,
  handle_off = function () awful.spawn.with_shell("pkill picom") end,
  toggle     = ToggleSwitch.toggle
}

local music_toggler = {
  is_toggled = true,
  handle_on  = function () awful.spawn.with_shell("mpc play") end,
  handle_off = function () awful.spawn.with_shell("mpc pause") end,
  toggle     = ToggleSwitch.toggle
}

return {
  picom_toggler = picom_toggler,
  music_toggler = music_toggler
}
