local c = {};

local _fonts = {};
---@type table<string,{func:function,caller:any}[]>
local _loadCallback = {};
function c.Cache(path, name)
    name = name or path;
    if _fonts[name] then
        print("error: has font.");
    end
    _fonts[name] = path;
    if _loadCallback[name] then
        local len = #_loadCallback[name];
        for i = len, 1, -1 do 
            local cb = _loadCallback[name][i];
            cb.func(cb.caller);
        end
    end
end

---@return string @使用Loader.getRes
function c.Get(name)
    return _fonts[name];
end

---@param name string
function c.Remove(name)
    _fonts[name] = nil;
end

function c.RegisterLoadCallback(fontname,func,caller)
    if not _loadCallback[fontname] then
        _loadCallback[fontname] = {};
    end
    table.insert(_loadCallback[fontname], {func=func,caller=caller});
end

function c.UnRegisterLoadCallback(fontname,func,caller)
    if _loadCallback[fontname] then
        local len = #_loadCallback[fontname];
        for i = len, 1, -1 do 
            local cb = _loadCallback[fontname][i];
            if cb.caller == caller and cb.func == func then
                table.remove(_loadCallback[fontname], i);
            end
        end 
    end
end

c.BaseFont = love.graphics.getFont();
return c;