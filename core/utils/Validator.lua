local class = require("class");
local EventDispatcher = require("node.modules.EventDispatcher");

---@class Fairy_Utils_Validator : Node_EventDispatcher
local c = class();

function c:ctor()
    EventDispatcher.ctor(self);

end

return c;