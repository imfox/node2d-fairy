local Class = require("class");
local UIKeys = require("fairy.core.utils.UIKeys");
local UIEvent = require("fairy.ui.event.UIEvent");
local Component = require("fairy.ui.Component");
local LoaderManager = require("fairy.core.net.LoaderManager");
local Loader = require("fairy.core.net.Loader");

---@class Fairy_UI_Image : Fairy_UI_Component
---@field skin string
local c = Class(Component);

function c:ctor(skin)
    Component.ctor(self);
    self:setter_getter("skin", self.__setSkin, self.__getSkin);
    self.skin = skin;
end

---@protected
function c:__setSkin(skin)
    if skin == "" or skin == nil then
        self._props[UIKeys.skin] = skin;
        self:measure();
    elseif type(skin) == "string" then
        self._props[UIKeys.skin] = skin;
        if Loader.getRes(skin) then
            self:measure();
        else
            self:once(UIEvent.LOADED, self.__onLoad, self);
            LoaderManager.instance:load(skin, Loader.IMAGE, true, nil, self);
        end
    else
        ---@type Image
        self._props[UIKeys.skin] = skin;
        self:measure();
    end
end

---@protected
function c:__getSkin()
    return self._props[UIKeys.skin];
end

---@protected
function c:__onLoad(url)
    if url == self.skin then
        self:measure();
    end
end

---@protected
function c:__draw(gr)
    local img;
    if self.skin == nil or self.skin == "" then
    elseif type(self.skin) == "string" then
        img = Loader.getRes(self.skin);
    else
        img = self.skin
    end
    if img then
        gr:draw(img);
    end
end

function c:measure()
    ---@type Image
    local img;
    local w, h = self._props[UIKeys.measuredWidth], self._props[UIKeys.measuredHeight];
    if self.skin == "" or self.skin == nil then
    elseif type(self.skin) == "string" then
        img = Loader.getRes(self.skin);
    else
        img = self.skin;
    end
    if img then
        self._props[UIKeys.measuredWidth] = img:getWidth() * self.scaleX;
        self._props[UIKeys.measuredHeight] = img:getHeight() * self.scaleY;
    else
        self._props[UIKeys.measuredWidth] = 0;
        self._props[UIKeys.measuredHeight] = 0;
    end
    if (self._width == nil or self._height == nil) and (w ~= self._props[UIKeys.measuredWidth] or h ~= self._props[UIKeys.measuredHeight]) then
        self:event(UIEvent.RESIZE);
    end
end

return c;

