local class = require("class")

---@class Fairy_Core_Utils_Pool : Class
local c = class();

---@type any[]
c.pools = {};

---@param sign string
---@param item any
function c:recover(sign, item)
    c.pools[sign] = item;

end

---@param sign string
function c:getItem(sign)
    local ls = c:getPoolBySign(sign);
    if #ls > 1 then
        return table.remove(ls, 1);
    end
end

---@param sign string
---@return any[]
function c:getPoolBySign(sign)
    if not c.pools[sign] then
        c.pools[sign] = {};
    end
    return c.pools[sign];
end

---@param sign string
function c:clearBySign(sign)
    if c.pools[sign] then
        c.pools[sign] = {};
    end
end

---@param sign string
---@param cls Class
function c:getItemByClass(sign, cls, ...)
    local item = c:getItem(sign);
    if not item then
        item = cls.new(...);
    end
    return item;
end

---@param sign string
---@param createFun fun
function c:getItemByCreateFun(sign, createFun, ...)
    local item = c:getItem(sign);
    if not item then
        item = createFun(...);
    end
    return item;
end

c.instance = c.new();
return c;