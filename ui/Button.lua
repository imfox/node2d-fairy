local Class = require("class");
local Image = require("fairy.ui.Image");
local TouchEvent = require("fairy.core.event.TouchEvent");

---@class Fairy_UI_Button : Fairy_UI_Image
---@field disabled boolean
local c = Class(Image);

function c:ctor()
    Image.ctor(self);

    ---@protected
    self._press = false;

    ---@protected
    self._disabled = nil;

    self:setter_getter("disabled", self.__setDisabled, self.__getDisabled);

    self.normalImage = nil;
    self.hoverImage = nil;
    self.pressImage = nil;
    self.disabledImage = nil;

    self.disabled = false;
end
---@protected
function c:__setDisabled(v)
    if self._disabled == v then
        return
    end
    self._disabled = v;
    if self._disabled then
        self:off(TouchEvent.TOUCH_HOVER, self.__onTouchHover, self);
        self:off(TouchEvent.TOUCH_BEGIN, self.__onTouchBegin, self);
        self:off(TouchEvent.TOUCH_END, self.__onTouchEnd, self);
        self:off(TouchEvent.TOUCH_RELEASE_OUTSIDE, self.__onTouchOutEnd, self);

        self.skin = self.disabledImage;
    else
        self:on(TouchEvent.TOUCH_HOVER, self.__onTouchHover, self);
        self:on(TouchEvent.TOUCH_BEGIN, self.__onTouchBegin, self);
        self:on(TouchEvent.TOUCH_END, self.__onTouchEnd, self);
        self:on(TouchEvent.TOUCH_RELEASE_OUTSIDE, self.__onTouchOutEnd, self);

        self.skin = self.normalImage;
    end

end

---@protected
function c:__getDisabled()
    return self._disabled;
end

---@param type string
---@param args any[]
---@return void
function c:event(type, args)
    if type == TouchEvent.TAP and self._disabled then
        return
    end
    Image.event(self, type, args);
end

function c:setImage(normal, hover, press, disable)
    self.normalImage = normal;
    self.hoverImage = hover;
    self.pressImage = press;
    self.disabledImage = disable;
    self.skin = normal;
end

---@protected
function c:__onTouchBegin()
    self.skin = self.hoverImage;
    self._press = true;
end

---@protected
function c:__onTouchEnd()
    --self.skin = self.normalImage;
    self:__onTouchOutEnd();
end

---@protected
function c:__onTouchHover()
    self.skin = self.hoverImage;
end

---@protected
function c:__onTouchOutEnd()
    self.skin = self.normalImage;
end

return c;

