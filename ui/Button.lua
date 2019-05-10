local Class = require("class");
local Image = require("fairy.ui.Image");
local TouchEvent = require("fairy.core.event.TouchEvent");
local UIKeys = require("fairy.core.utils.UIKeys");

---@class Fairy_UI_Button : Fairy_UI_Image
---@field disabled boolean
---@field normalImage string
---@field hoverImage string
---@field pressImage string
---@field disabledImage string
local c = Class(Image);

function c:ctor()
    Image.ctor(self);

    ---@protected
    self._press = false;

    ---@protected
    self._disabled = nil;

    ---@protected
    self.__state = 1;

    self:setter_getter("disabled", self.__setDisabled, self.__getDisabled);
    self:setter_getter("normalImage", self.__setNormalImage, self.__getNormalImage);
    self:setter_getter("hoverImage", self.__setHoverImage, self.__getHoverImage);
    self:setter_getter("pressImage", self.__setPressImage, self.__getPressImage);
    self:setter_getter("disabledImage", self.__setDisabledImage, self.__getDisabledImage);

    self.disabled = false;
end

function c:__setNormalImage(v)
    if v == self._props[UIKeys.normalImage] then
        return
    end
    self._props[UIKeys.normalImage] = v;
    self:__updateState();
end

function c:__getNormalImage()
    return self._props[UIKeys.normalImage];
end

function c:__setHoverImage(v)
    if v == self._props[UIKeys.hoverImage] then
        return
    end
    self._props[UIKeys.hoverImage] = v;
    self:__updateState();
end

function c:__getHoverImage()
    return self._props[UIKeys.hoverImage] or self.normalImage;
end

function c:__setPressImage(v)
    if v == self._props[UIKeys.pressImage] then
        return
    end
    self._props[UIKeys.pressImage] = v;
    self:__updateState();
end

function c:__getPressImage()
    return self._props[UIKeys.pressImage] or self.normalImage;
end

function c:__setDisabledImage(v)
    if v == self._props[UIKeys.disabledImage] then
        return
    end
    self._props[UIKeys.disabledImage] = v;
    self:__updateState();
end

function c:__getDisabledImage()
    return self._props[UIKeys.disabledImage] or self.normalImage;
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

        self.__state = 4;
    else
        self:on(TouchEvent.TOUCH_HOVER, self.__onTouchHover, self);
        self:on(TouchEvent.TOUCH_BEGIN, self.__onTouchBegin, self);
        self:on(TouchEvent.TOUCH_END, self.__onTouchEnd, self);
        self:on(TouchEvent.TOUCH_RELEASE_OUTSIDE, self.__onTouchOutEnd, self);

        self.__state = 1;
    end

    self:__updateState();

end

---@protected
function c:__getDisabled()
    return self._disabled;
end

---@param type string
---@param args any[]
---@return void
function c:event(type, args)
    if TouchEvent.IsTouchEvent(type) and self._disabled then
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
    self.__state = 3;
    self:__updateState();
end

---@protected
function c:__onTouchEnd()
    self:__onTouchOutEnd();

end

---@protected
function c:__onTouchHover()
    self.__state = 2;
    self:__updateState();

end

---@protected
function c:__onTouchOutEnd()
    self.__state = 1;
    self:__updateState();
end

---@protected
function c:__updateState()
    if self.__state == 1 then
        self.skin = self.normalImage;
    elseif self.__state == 2 then
        self.skin = self.hoverImage;
    elseif self.__state == 3 then
        self.skin = self.pressImage;
    elseif self.__state == 4 then
        self.skin = self.disabledImage;
    end
end
return c;

