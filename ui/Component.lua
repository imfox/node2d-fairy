local class = require("class");
local DisplayObject = require("fairy.core.display.DisplayObject");

---@class Fairy_UI_Component : Node_Core_Display_Drawable
local c = class(DisplayObject);

function c:ctor()
    DisplayObject.ctor(self);
    self.minWidth = 0;
    self.minHeight = 0;
    self.maxWidth = 10000;
    self.maxHeight = 100000;

end

return c;