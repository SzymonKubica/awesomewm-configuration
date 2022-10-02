local awful = require("awful")
local gears = require("gears")

-- The add_mapping function takes in a group and a description of a specific
-- action for which we want to create a key shortcut. Then the function returns
-- another function which accepts the combination of modifier keys and the
-- corresponding key to trigger the shortcut. Then that function returns a
-- function which takes in the actual action which we want to perform once the
-- key combination is pressed and returns the awful.key mapping.
-- The reason for that convoluted way of constructing the keybinding from
-- partial functions is to make the code for defining keybindings as concise
-- and descriptive as possible.
local function add_keybinding(description)
  return function(modifier_combination, trigger_key)
    return function(action)
      return function(group_name)
        return awful.key(
          modifier_combination,
          trigger_key,
          action,
          { description = description, group = group_name.group })
      end
    end
  end
end

local function join_group(group_name, keys, ...)
  for _, binding in pairs({...}) do
    keys = gears.table.join(keys, binding({ group = group_name }))
  end
  return keys
end

-- The primary modifier key is Control. That way there are two such keys on each
-- keyboard and hence shortcuts requiring pressing left-handed keys can be
-- triggered by pressing the left control.
local control = "Control"
-- The secondary modifier key is super. It is mainly used for actions involving
-- moving windows around.
local super = "Mod4"

return {
  add_keybinding = add_keybinding,
  join_group = join_group,
  control = control,
  super = super,
}
