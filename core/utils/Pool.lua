local class = require("class")

---@class Fairy_Core_Utils_Pool : Class
local c = class();

---@type any[]
c.pools = {};

---@param sign string
---@param item any
function c:Recover(sign, item)
    c.pools[sign] = item;

end

---@param sign string
function c:GetItem(sign)
    local ls = c:GetPoolBySign(sign);
    if #ls > 1 then
        return table.remove(ls, 1);
    end
end

---@param sign string
---@return any[]
function c:GetPoolBySign(sign)
    if not c.pools[sign] then
        c.pools[sign] = {};
    end
    return c.pools[sign];
end

---@param sign string
function c:ClearBySign(sign)
    if c.pools[sign] then
        c.pools[sign] = {};
    end
end

---@param sign string
---@param cls Class
function c:GetItemByClass(sign, cls, ...)
    local item = c:GetItem(sign);
    if not item then
        item = cls.new(...);
    end
    return item;
end

---@param sign string
---@param createFun fun
function c:GetItemByCreateFun(sign, createFun, ...)
    local item = c:GetItem(sign);
    if not item then
        item = createFun(...);
    end
    return item;
end

c.instance = c.new();
return c;