local Class = require("class");
local RadioButton = require("fairy.ui.RadioButton");

---@class Fairy_UI_Button : Fairy_UI_RadioButton
local c = Class(RadioButton);

function c:ctor()
    RadioButton.ctor(self);
    self.group = nil
end

function c:setImage(normal, hover, press, disable)
    RadioButton.setImage(self, normal, hover, press, press, disable)
end

---@protected
function c:__onTouchEnd()
    if not self.selected then
        self.__state = 2
        self:__updateState()
    end
end

return c;

