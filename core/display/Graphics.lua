local Class = require("class");

local gr = love.graphics;
local translate, pop, push, applyTransform, newTransform = gr.translate, gr.pop, gr.push, gr.applyTransform, love.math.newTransform
local getColor, setColor = gr.getColor, gr.setColor
local setBlendMode, getBlendMode = gr.setBlendMode, gr.getBlendMode

---@class Fairy_Core_Display_Graphics
local c = Class();

---@param display Node_Core_Display_Drawable
function c:ctor(display)
    self.display = display;

    self.x = 0;
    self.y = 0;
    self.scaleX = 1;
    self.scaleY = 1;
    self.pivotX = 0;
    self.pivotY = 0;
    self.rotation = 0;

    ---@type boolean @下一次渲染前是否需要重算矩阵
    self._testTransfrom = false;

end

---@param img Image
function c:draw(img)
    gr.draw(img, self.x, self.y, self.rotation, self.scaleX * (self.display.width / img:getWidth()), self.scaleY * (self.display.height / img:getHeight()), self.pivotX, self.pivotY);
end

function c:drawGrid(img)

end

function c:print(text, align)
    gr.printf(text, self.x, self.y, self.display.width, align, self.rotation, self.scaleX, self.scaleY, self.pivotX, self.pivotY);
end

function c:_push()
    local display = self.display;

    local state = {};
    state.r, state.g, state.b, state.a = getColor()

    state.blendMode = getBlendMode();
    if display.alpha < 1 then
        setColor(state.r, state.g, state.b, state.a * display.alpha);
    end
    if display.blendMode then
        setBlendMode(display.blendMode);
    end

    local x, y = 0, 0
    if display.parent then
        local parent = display.parent.graphics;
        x = parent.x + display.x;
        y = parent.y + display.y;
    end
    if display.transform then
        if self._testTransfrom then
            self:__calcTransfrom(x, y, display.rotation, display._scaleX, display._scaleY);
            self._testTransfrom = false;
        end
        push()
        applyTransform(display.transform);
        self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.pivotX, self.pivotY = 0, 0, 0, 1, 1, 0, 0;
    else
        self.x, self.y = x, y;
        self.scaleX = display.scaleX;
        self.scaleY = display.scaleY;
        self.rotation = math.rad(display.rotation);
    end
    self.pivotX, self.pivotY = display.pivotX, display.pivotY;
    return state;
end

function c:_pop(state)
    local display = self.display;
    if display.alpha < 1 then
        setColor(state.r, state.g, state.b, state.a);
    end
    if display.blendMode then
        setBlendMode(state.blendMode);
    end
    if display.transform then
        pop()
    end
end

---@protected
function c:__calcTransfrom(x, y, r, sx, sy)
    local display = self.display;
    if display.transform then
        display.transform:reset();
        display.transform:translate(x, y);
        display.transform:rotate(math.rad(r or 0));
        display.transform:scale(sx or 1, sy or 1);
    end
end

return c;