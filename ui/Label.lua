local class = require("class");
local Component = require("fairy.ui.Component");
local UIKeys = require("fairy.core.utils.UIKeys");
local FontManager = require("fairy.core.utils.FontManager");
local Loader = require("fairy.core.net.Loader");

---@class Fairy_UI_Label : Fairy_UI_Component
---@field font string
---@field align AlignMode
---@field text string
local c = class(Component);

function c:ctor(text)
    Component.ctor(self);
    self:setter_getter("font", self.__setFont, self.__getFont);
    self.align = "left";
    self.text = text;
end

function c:__setFont(v)
    if v == self._props[UIKeys.font] then
        return
    end
    if not FontManager.Get(v) then
        print("error: don't find font.");
    end
    self._props[UIKeys.font] = v;
end

function c:__getFont()
    return self._props[UIKeys.font];
end

---@protected
---@param gr Fairy_Core_Display_Graphics
function c:__draw(gr)
    local f = love.graphics.getFont();

    local nf = Loader.getRes(FontManager.Get(self.font));
    if nf then
        love.graphics.setFont(nf);
    end

    if self.text and self.text ~= "" then
        gr:print(self.text, self.align);
    end

    love.graphics.setFont(f);
end

---@protected
function c:__getMeasuredWidth()
    ---@type Font
    local nf = Loader.getRes(FontManager.Get(self.font));
    if nf and self.text then
        return nf:getWidth(tostring(self.text));
    end
    return 0;
end

---@protected
function c:__getMeasuredHeight()
    ---@type Font
    local nf = Loader.getRes(FontManager.Get(self.font));
    if nf and self.text then
        return nf:getHeight(tostring(self.text));
    end
    return 0;
end

return c;

