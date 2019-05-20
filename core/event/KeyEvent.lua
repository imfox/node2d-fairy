---@class Fariy_Core_Event_KeyEvent
local c = {}
c.KEY_DOWN = "KEY_DOWN"
c.KEY_UP = "KEY_UP"

function c.IsDown(key)
    return love.keyboard.isDown(key)
end

return c;


