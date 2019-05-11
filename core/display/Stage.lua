local Class = require("class");
local Drawable = require("fairy.core.display.DisplayObject");
local Event = require("node.modules.Event");
local FEvent = require("fairy.core.event.Event");
local TouchManager = require("fairy.core.event.TouchManager");
local gr = love.graphics;

---@class Node_Core_Display_Stage : Node_Core_Display_Drawable
local c = Class(Drawable);
function c:ctor()
    Drawable.ctor(self);

    self.offsetX = 0;
    self.offsetY = 0;
    self.screenScaleX = 1;
    self.screenScaleY = 1;
    self._bgColor = nil;
    self.bgColor = 0xffffff;

    self._scaleMode = "SHOWALL";

    Drawable._STC_stage = self;
end

function c:update(dt)
    TouchManager.instance:runEvent();
    for _, dr in ipairs(Drawable._STC_renderCallbackList) do
        dr:event(FEvent.RENDER);
    end
    for _, dr in ipairs(Drawable._STC_enterFrameCallbackList) do
        dr:event(FEvent.ENTER_FRAME);
    end
end

function c:draw()
    gr.reset();
    gr.push();
    gr.translate(self.offsetX, self.offsetY);
    gr.scale(self.screenScaleX, self.screenScaleY);
    self:__render();
    gr.pop();

    if self.offsetX ~= 0 or self.offsetY ~= 0 then
        --隐藏其它...比较搓
        local w, h = gr.getWidth(), gr.getHeight()
        gr.setColor(0.1, 0.1, 0.1, 1)
        gr.rectangle("fill", 0, 0, self.offsetX, h)
        gr.rectangle("fill", 0, 0, w, self.offsetY)
        gr.rectangle("fill", w - self.offsetX, 0, self.offsetX, h)
        gr.rectangle("fill", 0, h - self.offsetY, w, self.offsetY)
        gr.setColor(1, 1, 1, 1)
    end

end

---@param w number
---@param h number
function c:setSceenSize(w, h)
    self:event(Event.RESIZE);

    local sw = gr.getWidth();
    local sh = gr.getHeight();

    self.width = w;
    self.height = h;

    local minScale = math.min(sw / self.width, sh / self.height)
    self.screenScaleX, self.screenScaleY = minScale, minScale
    self.offsetX, self.offsetY = (sw - (self.width * minScale)) / 2, (sh - (self.height * minScale)) / 2;
end

function c:keyboardEvent()
    --TouchManager:onTouch(Event.MOUSE_DOWN, 1, 115, 877)
end

---@private
function c:touchPoint(x, y)
    x = x - self.offsetX
    x = x / (self.screenScaleX * self.width) * self.width
    if (x < 0 or x > self.width) then
        x = -1
    end

    y = y - self.offsetY
    y = y / (self.screenScaleY * self.height) * self.height
    if (y < 0 or y > self.height) then
        y = -1;
    end
    return x, y
end

---@param type string
---@param id any
---@param x number
---@param y number
function c:onMouseEvent(type, id, x, y)
    local nx, ny = self:touchPoint(x, y);
    if nx > 0 and ny > 0 then
        TouchManager.instance:onTouch(type, id, nx, ny);
    end
end

function c:_changeWindowSize()
    self:setSceenSize(self.width, self.height);
end

c.instance = c.new();
TouchManager.instance:setStage(c.instance);
return c;
