local Array = {}

---@param t table
---@param v any
---@return number
function Array.IndexOf(t, v)
    for index, value in ipairs(t) do
        if value == v then
            return index;
        end

    end
    return 0;
end

---@param t any[]
---@param cb fun(value:any,index:number,array:any[]):any
---@return any[]
function Array.Map(t, cb)
    local ret = {};
    for i, v in ipairs(t) do
        table.insert(ret, cb(v, i, t));
    end
    return ret;
end

---@param t any[]
---@param cb fun(value:any,index:number,array:any[]):any
function Array.ForEach(t, cb)
    for i, v in ipairs(t) do
        cb(v, i, t);
    end
end

---@param t table
---@return any
function Array.Pop(t)
    if #t > 0 then
        return table.remove(t, #t);
    end
end

local Number = {};
--num.NaN = -(0 / 0);
Number.POSITIVE_INFINITY = 1 / 0;

---@param n number
---@return boolean
function Number.IsNan(n)
    return n == -(0 / 0) or n == 0 / 0;
end

local Commom = {};
Commom.Array = Array;
Commom.Number = Number;

return Commom;