local class = require("class");
local UIKeys = require("fairy.core.utils.UIKeys");
local DisplayObject = require("fairy.core.display.DisplayObject");
local UIEvent = require("fairy.ui.event.UIEvent");

---@class Fairy_UI_Component : Node_Core_Display_Drawable
---@field minWidth number
---@field maxWidth number
---@field minHeight number
---@field maxHeight number
---@field measuredWidth number
---@field measuredHeight number
---@field anchorX number
---@field anchorY number
local c = class(DisplayObject);

function c:ctor()
    DisplayObject.ctor(self);

    ---@protected
    self._props = {};

    self:setter_getter("minWidth", self.__setMinHeight, self.__getMinWidth);
    self:setter_getter("maxWidth", self.__setMaxWidth, self.__getMaxWidth);
    self:setter_getter("minHeight", self.__setMinHeight, self.__getMinHeight);
    self:setter_getter("maxHeight", self.__setMaxHeight, self.__getMaxHeight);

    self:getter("measuredWidth", self.__getMeasuredWidth);
    self:getter("measuredHeight", self.__getMeasuredHeight);

    self:setter_getter("anchorX", self.__setAnchorX, self.__getAnchorX);
    self:setter_getter("anchorY", self.__setAnchorY, self.__getAnchorY);

    --self:setter_getter("pivotX", self.__setPivotX, self.__setPivotX);
    --self:setter_getter("pivotY", self.__setPivotY, self.__setPivotY);

    self.minWidth = 0;
    self.minHeight = 0;
    self.maxWidth = 10000;
    self.maxHeight = 100000;

end

---@protected
function c:__setX(v)
    if self._x ~= v then
        DisplayObject.__setX(self, v);
        self:event(UIEvent.MOVE);
    end
end

---@protected
function c:__setY(v)
    if self._y ~= v then
        DisplayObject.__setY(self, v);
        self:event(UIEvent.MOVE);
    end
end

--function c:__setPivotX(v)
--end
--function c:__getPivotX()
--end
--function c:__setPivotY(v)
--end
--function c:__getPivotY()
--end

---@protected
function c:__setAnchorX(v)
    if v == self._props[UIKeys.anchorX] then
        return
    end
    self._props[UIKeys.anchorX] = v;
    self:__resize();
end
---@protected
function c:__getAnchorX()
    return self._props[UIKeys.anchorX];
end

---@protected
function c:__setAnchorY(v)
    if v == self._props[UIKeys.anchorY] then
        return
    end
    self._props[UIKeys.anchorY] = v;
    self:__resize();
end
---@protected
function c:__getAnchorY()
    return self._props[UIKeys.anchorY];
end

---@protected
function c:__setMinWidth(value)
    value = math.abs(value) or 0;
    if (value < 0 or self._props[UIKeys.minWidth] == value) then
        return
    end
    self._props[UIKeys.minWidth] = value;
end

---@protected
function c:__getMinWidth()
    return self._props[UIKeys.minWidth] or 0;
end

---@protected
function c:__setMaxWidth(value)
    value = math.abs(value) or 0;
    if (value < 0 or self._props[UIKeys.maxWidth] == value) then
        return
    end
    self._props[UIKeys.maxWidth] = value;
end

---@protected
function c:__getMaxWidth()
    return self._props[UIKeys.maxWidth] or 0;
end

---@protected
function c:__setMinHeight(value)
    value = math.abs(value) or 0;
    if (value < 0 or self._props[UIKeys.minHeight] == value) then
        return
    end
    self._props[UIKeys.minHeight] = value;
end

---@protected
function c:__getMinHeight()
    return self._props[UIKeys.minHeight] or 0;
end

---@protected
function c:__setMaxHeight(value)
    value = math.abs(value) or 0;
    if (value < 0 or self._props[UIKeys.maxHeight] == value) then
        return
    end
    self._props[UIKeys.maxHeight] = value;
end

---@protected
function c:__getMaxHeight()
    return self._props[UIKeys.maxHeight] or 0;
end

---@protected
function c:__setWidth(v)
    local w = self.width;
    if v < self.minWidth then
        v = self.minWidth;
    end
    if v > self.maxWidth then
        v = self.maxWidth;
    end
    DisplayObject.__setWidth(self, v);
    if w ~= self.width then
        self:__resize();
        self:event(UIEvent.RESIZE);
    end
end

---@protected
function c:__getWidth()
    if self._width == nil then
        return self.measuredWidth;
    end
    return DisplayObject.__getWidth(self);
end

---@protected
function c:__setHeight(v)
    local h = self.height;
    if v < self.minHeight then
        v = self.minHeight;
    end
    if v > self.maxHeight then
        v = self.maxHeight;
    end
    DisplayObject.__setHeight(self, v);
    if h ~= self.height then
        self:__resize();
        self:event(UIEvent.RESIZE);
    end
end

---@protected
function c:__getHeight()
    if self._height == nil then
        return self.measuredHeight;
    end
    return DisplayObject.__getHeight(self);
end

---@protected
function c:__resize()
    if self.anchorX ~= nil then
        self.pivotX = self.width * self.anchorX;
    end
    if self.anchorY ~= nil then
        self.pivotY = self.height * self.anchorY;
    end
end

function c:measure()
end

---@protected
function c:__getMeasuredWidth()
    return self._props[UIKeys.measuredWidth];
end

---@protected
function c:__getMeasuredHeight()
    return self._props[UIKeys.measuredHeight];
end

---@param x number
---@param y number
function c:anchor(x, y)
    self.anchorX = x;
    self.anchorY = y;
    return self;
end

return c;