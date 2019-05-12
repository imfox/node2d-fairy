local class = require("class");
local Component = require("fairy.ui.Component");
local UIKeys = require("fairy.core.utils.UIKeys");
local FontManager = require("fairy.core.utils.FontManager");
local Loader = require("fairy.core.net.Loader");
local Utils = require("fairy.core.utils.Utils");


---@param text string
---@return string[]
local function splitChar(str,tv)
	local t = tv or {}
	local i = 1
	local ascii = 0
	while true do
		ascii = string.byte(str, i)
		if ascii then
			if ascii < 127 then
				table.insert(t,string.sub(str, i, i))
				i = i+1
			else
				table.insert(t,string.sub(str, i, i+1))
			    i = i+2
			end
		else
		    break
		end
	end
	return t
end

---@param text string
---@param px number @像素
---@param font Font
local function splitText(text,px,font)
    local chars = {};
    local strs = {};
    splitChar(text, chars);
    local str = "";
    for i, c in ipairs(chars) do
        if c == "\n" then
            table.insert(strs,"");
            str = "";
        elseif font:getWidth(str .. c) > px then
            table.insert(strs,str);
            str = c;
        else
            str = str .. c;
        end
    end
    if #str > 0 then
        table.insert(strs,str);
    end
    return strs;
end

---@class Fairy_UI_Label : Fairy_UI_Component
---@field font string
---@field align AlignMode
---@field text string
---@field valign VAlignMode
---@field textFlow any[]
---@field tetxtColor string
---@field strokeColor string
---@field stroke number
---@field lineSpacing number
---@field text string
local c = class(Component);

function c:ctor(text)
    Component.ctor(self);

    self:setter_getter("font", self.__setFont, self.__getFont);
    self:setter_getter("text", self.__setText, self.__getText);
    self:setter_getter("textFlow", self.__setTextFlow, self.__getTextFlow);

    self.lineSpacing = 0;
    self.__textArr = {};
    self.align = "left";
    self.valign = "top";
    
    self.text = text;
    
end

---@protected
function c:__setText(v)
    if v == self._props[UIKeys.text] then
        return
    end
    self._props[UIKeys.text] = v;
    self:__adjust();
end

---@protected
function c:__getText()
    return self._props[UIKeys.text];
end

---@protected
function c:__setTextFlow(v)
    if v == self._props[UIKeys.textFlow] then
        return
    end
    self._props[UIKeys.textFlow] = v;
end

---@protected
function c:__getTextFlow()
    return self._props[UIKeys.textFlow];
end

---@protected
function c:__adjust()
    local v = self.text;
    self.__textArr = {};
    table.insert(self.__textArr, v);
    self:measure();
end

---@protected
function c:__setFont(v)
    if v == self._props[UIKeys.font] then
        return
    end
    if self.font then
        FontManager.UnRegisterLoadCallback(self.font, self.__adjust, self);
    end
    if not FontManager.Get(v) then
        FontManager.RegisterLoadCallback(v, self.__adjust, self);
        print("error: don't find font.");
    else
        self:__adjust();
    end
    self._props[UIKeys.font] = v;
end

function c:__getFont()
    return self._props[UIKeys.font];
end

---@overload
function c:__setWidth(v)
    Component.__setWidth(self,v);
    self:measure();
end

---@overload
function c:__setHeight(v)
    Component.__setHeight(self,v);
    self:measure();
end

---@protected
function c:measure()
    self._props[UIKeys.measuredHeight] = nil;
    self._props[UIKeys.measuredWidth] = nil;
    if self.__textArr[1] then
        local font = self:_getFont();
        local w = 0;
        local lines = 0;
        for _, v in ipairs(self.__textArr) do
            if type(v) == "string" then
                local len = font:getWidth(v);
                if len > w then
                    w = len;
                end
                if self._width then
                    lines = lines + math.ceil(len / self._width);
                else
                    lines = lines + 1;
                end
            end
        end
        local h = lines * (self.lineSpacing + font:getHeight());
        self._props[UIKeys.measuredWidth] = w; 
        self._props[UIKeys.measuredHeight] = h;
    end
    self:__resize();
end

---@protected
---@param gr Fairy_Core_Display_Graphics
function c:__draw(gr)
    if self.__textArr and self.__textArr[1] then
        
        ---@type Font
        local font = self:_getFont();
        if font then
            love.graphics.setFont(font);
            local fs = font:getHeight();
            font:setLineHeight((self.lineSpacing + fs) / fs);
        end

        gr:printf(self.__textArr);
    end
end

---@private
---@return Font
function c:_getFont()
    return Loader.getRes(FontManager.Get(self.font)) or FontManager.BaseFont;
end

return c;

---@class VAlignMode
---@field top string
---@field bottom string
---@field middle string