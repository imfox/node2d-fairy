local Class = require("class");
local Utils = require("fairy.core.utils.Utils");
local EventDispatcher = require("node.modules.EventDispatcher");
local UIEvent = require("fairy.ui.event.UIEvent");
local FontManager = require("fairy.core.utils.FontManager");

local exist = love.filesystem.getInfo;

local _cache = {};

---@class Fairy_Core_Net_Loader : Node_EventDispatcher
---@field _cache table<string,any> @缓存
local Loader = Class(EventDispatcher);

Loader.FONT = "FONT";
Loader.TABLE = "TABLE";
Loader.SOUND = "SOUND";
Loader.IMAGE = "IMAGE";
Loader.TXT = "TXT";

---@private
Loader.extKeys = {
    png = Loader.IMAGE,
    jpg = Loader.IMAGE,
    jpeg = Loader.IMAGE,
    fnt = Loader.FONT,
    ttf = Loader.FONT,
    mp3 = Loader.SOUND,
    wav = Loader.SOUND,
    txt = Loader.TXT,
}

function Loader:ctor()
    EventDispatcher.ctor(self);
    self:getter("_cache", self.__getCache);

    ---@protected
    self._list = {};
end

function Loader.__getCache()
    return _cache;
end

---@param url string | LoaderArray[]
---@param type_ string
---@param cache boolean
---@return Fairy_Core_Net_Loader
function Loader:load(url, type_, cache)
    if not url then
        return
    end

    if type(url) == "table" then
        for _, item in ipairs(url) do
            self:load(item.url, item.type)
        end
        return ;
    end

    if not type_ then
        local ext = Loader.extKeys[Utils.GetExtension(url)];
        if ext then
            type_ = ext;
        end
    end
    type_ = type_ or Loader.IMAGE;
    cache = cache or true;

    local data = Loader.getRes(url);

    if not data then
        if not exist(url) then
            print("error : not exits file:" .. url);
            return
        end
    end

    if not data then
        if type_ == Loader.IMAGE then
            data = love.graphics.newImage(url);
        elseif type_ == Loader.FONT then
            data = love.graphics.newFont(url)
        elseif type_ == Loader.TXT then
            data = love.filesystem.read(url);
        elseif type_ == Loader.TABLE then
            local content = love.filesystem.read(url);
            data = loadstring(content)();
        elseif type_ == Loader.SOUND then
            -- 这里做缓存
        elseif type_ == "IMAGEPACK" then
            -- 这里做切图
        else
            print(string.format("error : unknown type resource(不可识别的资源) type:%s path:%s", type_, url));
        end

        if cache then
            Loader.cacheRes(url, data);
        end
    end

    if data then
        self:event(UIEvent.LOADED, { url });
    end

    return self;

end

---@param url string
---@param data any
function Loader.cacheRes(url, data)
    if data then
        if data.type then
            if data:type() == "Font" then
                FontManager.Cache(url, Utils.Stripextension(Utils.GetFileName(url)));
                FontManager.Cache(url, Utils.GetFileName(url));
                FontManager.Cache(url);
            end
        end
        _cache[url] = data;
    end
end

---@param url string
function Loader.getRes(url)
    if _cache[url] then
        return _cache[url];
    end
end

function Loader.clearRes(url)
    if _cache[url] then
        local obj = _cache[url];
        if obj.type then
            if obj:type() == "Font" then
                FontManager.Remove(url, Utils.Stripextension(Utils.GetFileName(url)));
                FontManager.Remove(url, Utils.GetFileName(url));
                FontManager.Remove(url);
            end
        end
        if obj.release then
            obj:release();
        end
        obj = nil;
        _cache[url] = nil;
    end
end

return Loader;

---@class LoaderArray
---@field url string
---@field type string