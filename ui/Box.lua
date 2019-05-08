local Class = require("class");
local UIKeys = require("fairy.core.utils.UIKeys");
local Component = require("fairy.ui.Component");
local UIEvent = require("fairy.ui.event.UIEvent");

---@class Fairy_UI_Box : Fairy_UI_Component
---@field skin string
local c = Class(Component);

function c:ctor()
    Component.ctor(self);

    ---@protected
    self.__ox = 0;
    ---@protected
    self.__oy = 0;

end

---@overload
---@param node Node_Core_Display_Drawable
---@param index number
---@return Node_Core_Display_Drawable
function c:addChildAt(node, index)
    local ret = Component.addChildAt(self, node, index);
    node:on(UIEvent.MOVE_POS, self.measure, self);
    node:on(UIEvent.RESIZE, self.measure, self);
    self:measure();
    return ret;
end

---@overload
---@param index number
---@return Node_Node
function c:removeChildAt(index)
    local node = Component.removeChildAt(self, index);
    node:off(UIEvent.MOVE_POS, self.measure, self);
    node:off(UIEvent.RESIZE, self.measure, self);
    self:measure();
    return node;
end

function c:measure()
    local maxH = 0;
    local minY = 0;

    local minX = 0;
    local maxW = 0;
    for i = self:numChild(), 1, -1 do
        ---@type Node_Core_Display_Drawable
        local comp = self:getChildAt(i);
        if comp.visible then
            maxH = math.max(comp.y + comp.height * comp.scaleY, maxH);
            maxW = math.max(comp.x + comp.width * comp.scaleX, maxW);

            minX = math.min(comp.x, minX);
            minY = math.min(comp.y, minY);
        end
    end

    self.__ox = minX;
    self.__oy = minY;

    --  宽度或者高度为0，不会经过 hitTest 方法
    if maxW <= 0 and self.__ox ~= 0 then
        maxW = 1;
    end
    if maxH <= 0 and self.__oy ~= 0 then
        maxH = 1;
    end

    self._props[UIKeys.measuredWidth] = maxW;
    self._props[UIKeys.measuredHeight] = maxH;

end

---@overload
---@param x1 number
---@param y1 number
---@return boolean @只需要检测原始宽高即可 缩放系数已经在 x,y 中处理
function c:hitTest(x1, y1)
    return x1 > self.__ox and y1 > self.__oy and x1 <= self.width and y1 <= self.height;
end

return c;

