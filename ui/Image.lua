local Class = require("class");
local UIKeys = require("fairy.core.utils.UIKeys");
local Component = require("fairy.ui.Component");

---@class Fairy_UI_Image : Fairy_UI_Component
---@field skin string
local c = Class(Component);

function c:ctor(skin)
    Component.ctor(self);

    ---@protected
    self._skin = nil;

    self:setter_getter("skin", self.__setSkin, self.__getSkin);

    self.skin = skin;
end

function c:__setSkin(skin)
    if type(skin) == "string" then
        -- load
    else
        ---@type Image
        self._skin = skin;
        self:measure();
    end
end

function c:__getSkin()
    return self._skin;
end

function c:__draw(gr)
    if type(self.skin) == "string" then

    else
        gr:draw(self.skin);
    end
end

function c:measure()
    if type(self.skin) == "string" then

    elseif type(self.skin) ~= "nil" then
        ---@type Image
        local img = self.skin;
        self._props[UIKeys.measuredWidth] = img:getWidth() * self.scaleX;
        self._props[UIKeys.measuredHeight] = img:getHeight() * self.scaleY;
    end

end

return c;

