local Class = require("class");
local Image = require("fairy.ui.Image");
local TouchEvent = require("fairy.core.event.TouchEvent");
local Event = require("node.modules.Event");
local UIKeys = require("fairy.core.utils.UIKeys");
local UIEvent = require("fairy.ui.event.UIEvent");

---@class Fairy_UI_RadioButton : Fairy_UI_Image
---@field selected boolean
---@field disabled boolean
---@field normalImage string
---@field hoverImage string
---@field pressImage string
---@field selectImage string
---@field disabledImage string
---@field group string 默认值为group
local c = Class(Image);

function c:ctor()
    Image.ctor(self);

    ---@protected
    self._disabled = nil;

    ---@protected
    ---@type number
    self.__state = 1;

    self.group = "group";

    self:setter_getter("disabled", self.__setDisabled, self.__getDisabled);
    self:setter_getter("normalImage", self.__setNormalImage, self.__getNormalImage);
    self:setter_getter("hoverImage", self.__setHoverImage, self.__getHoverImage);
    self:setter_getter("pressImage", self.__setPressImage, self.__getPressImage);
    self:setter_getter("selectImage", self.__setSelectImage, self.__getSelectImage);
    self:setter_getter("disabledImage", self.__setDisabledImage, self.__getDisabledImage);
    self:setter_getter("selected", self.__setSelect, self.__getSelect);

    self.disabled = false;
end

---@protected
---@param b boolean
function c:__setSelect(b)
    if not self.disabled and b ~= self.selected then
        if b then
            self.__state = 5
            if self.group and self.parent then
                self.parent:event(UIEvent.CHANGE_RADIO, { self, self.group })
            end
            self:event(UIEvent.CHANGE)
        else
            self.__state = 1
        end
        self:__updateState()
    end
end

---@protected
function c:__getSelect()
    return self.__state == 5 -- or self.__state == 3
end
---@protected
function c:__setNormalImage(v)
    if v == self._props[UIKeys.normalImage] then
        return
    end
    self._props[UIKeys.normalImage] = v;
    self:__updateState();
end
---@protected
function c:__getNormalImage()
    return self._props[UIKeys.normalImage];
end
---@protected
function c:__setHoverImage(v)
    if v == self._props[UIKeys.hoverImage] then
        return
    end
    self._props[UIKeys.hoverImage] = v;
    self:__updateState();
end
---@protected
function c:__getHoverImage()
    return self._props[UIKeys.hoverImage] or self.normalImage;
end
---@protected
function c:__setPressImage(v)
    if v == self._props[UIKeys.pressImage] then
        return
    end
    self._props[UIKeys.pressImage] = v;
    self:__updateState();
end
---@protected
function c:__getPressImage()
    return self._props[UIKeys.pressImage] or self.normalImage;
end
---@protected
function c:__setSelectImage(v)
    if v == self._props[UIKeys.selectImage] then
        return
    end
    self._props[UIKeys.selectImage] = v;
    self:__updateState();
end
---@protected
function c:__getSelectImage()
    return self._props[UIKeys.selectImage] or self.pressImage or self.normalImage;
end
---@protected
function c:__setDisabledImage(v)
    if v == self._props[UIKeys.disabledImage] then
        return
    end
    self._props[UIKeys.disabledImage] = v;
    self:__updateState();
end

---@protected
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
        self:off(TouchEvent.TOUCH_ENTER, self.__onTouchHover, self);
        self:off(TouchEvent.TOUCH_OUT, self.__onTouchOut, self);
        self:off(TouchEvent.TOUCH_BEGIN, self.__onTouchBegin, self);
        self:off(TouchEvent.TOUCH_END, self.__onTouchEnd, self);
        self:off(TouchEvent.TOUCH_RELEASE_OUTSIDE, self.__onTouchOutEnd, self);
        self:off(Event.ADDED, self.__changeCallback, self);
        self:off(Event.BEFORE_REMOVE, self.__removeCallback, self);
        self.__state = 4;
    else
        self:on(TouchEvent.TOUCH_ENTER, self.__onTouchHover, self);
        self:on(TouchEvent.TOUCH_OUT, self.__onTouchOut, self);
        self:on(TouchEvent.TOUCH_BEGIN, self.__onTouchBegin, self);
        self:on(TouchEvent.TOUCH_END, self.__onTouchEnd, self);
        self:on(TouchEvent.TOUCH_RELEASE_OUTSIDE, self.__onTouchOutEnd, self);
        self:on(Event.ADDED, self.__changeCallback, self);
        self:on(Event.BEFORE_REMOVE, self.__removeCallback, self);
        self.__state = 1;
    end
    self:__updateState();

end

---@protected
---@param child Fairy_UI_RadioButton
---@param group
function c:__selectChild(child, group)
    if group == self.group and child ~= self and self.selected then
        self.selected = false
    end
end

---@protected
function c:__changeCallback()
    self.parent:on(UIEvent.CHANGE_RADIO, self.__selectChild, self)
end

---@protected
function c:__removeCallback()
    self.parent:off(UIEvent.CHANGE_RADIO, self.__selectChild, self)
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

function c:setImage(normal, hover, press, select, disable)
    self.normalImage = normal;
    self.hoverImage = hover;
    self.pressImage = press;
    self.selected = select;
    self.disabledImage = disable;
    self:__updateState();
end

---@protected
function c:__onTouchBegin()
    if not self.selected then
        self.__state = 3;
        self:__updateState();
    end
end

---@protected
function c:__onTouchEnd()
    if not self.selected then
        if self.__state == 3 then
            self.selected = true
        end
    end
end

---@protected
function c:__onTouchHover()
    if not self.selected and self.__state ~= 3 then
        self.__state = 2;
        self:__updateState();
    end
end

---@protected
function c:__onTouchOut()
    if not self.selected and self.__state ~= 3 then
        self.__state = 1;
        self:__updateState();
    end
end

---@protected
function c:__onTouchOutEnd()
    if not self.selected then
        self.__state = 1;
        self:__updateState();
    end
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
    elseif self.__state == 5 then
        self.skin = self.selectImage;
    end
end

return c;

