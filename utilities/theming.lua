local gears  = require("gears")
local common = require("common")

local function set_wallpaper(s)
    -- Wallpaper
    if common.beautiful.wallpaper then
        local wallpaper = common.beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false, {0, 0})
    end
end

local round_corners = function(cr, w, h)
		 gears.shape.rounded_rect(cr, w, h, 25)
end

return {
  set_wallpaper = set_wallpaper,
  round_corners = round_corners
}
