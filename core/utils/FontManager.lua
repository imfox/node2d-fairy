local c = {};

local _fonts = {};
function c.Cache(path, name)
    name = name or path;
    if _fonts[name] then
        print("error: has font.");
    end
    _fonts[name] = path;
end

---@return string @使用Loader.getRes
function c.Get(name)
    return _fonts[name];
end

---@param name string
function c.Remove(name)
    _fonts[name] = nil;
end

return c;