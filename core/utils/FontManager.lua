local c = {};

local _fonts = {};
function c.Cache(path, name)
    if _fonts[name] then
        print("error: has font.");
    end
    _fonts[name] = path;
end

function c.Get(name)
    return _fonts[name];
end

---@param path string
function c.GetByPath(path)
    for k, v in pairs(_fonts) do
        if v == path then
            return c.Get(k);
        end
    end
end

return c;