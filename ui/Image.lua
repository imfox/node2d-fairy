local Class = require("class");
local DisplayObject = require("fairy.core.display.DisplayObject");

---@class Fairy_UI_Image : Node_Core_Display_Drawable
local c = Class(DisplayObject);

function c:ctor()
    DisplayObject.ctor(self);

    ---@public
    self.skin = "";

end

function c:__draw(gr)
    if type(self.skin) == "string" then

    else
        gr:draw(self.skin);
    end
end

return c;

