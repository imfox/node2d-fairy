local Class = require("class");
local EventDispatcher = require("node.modules.EventDispatcher");
local Loader = require("fairy.core.net.Loader");
local UIEvent = require("fairy.ui.event.UIEvent");

---@class Fairy_Core_Net_LoaderManager : Node_EventDispatcher
local c = Class(EventDispatcher);

function c:ctor()
    EventDispatcher.ctor(self);

    ---@protected
    self._loader = Loader.new();
    self._loader:on(UIEvent.LOADED, self.__onload, self);

    ---@type Node_EventDispatcher[]
    self._callbacks = {};

end

---@protected
function c:__onload(url)
    if self._callbacks[url] then
        self._callbacks[url]:event(UIEvent.LOADED, { url });
        self._callbacks[url] = nil;
    end
end

---@param url string
---@param type string
---@param cache boolean
---@param group string
---@param obj Node_EventDispatcher
---@return Fairy_Core_Net_LoaderManager
function c:load(url, type, cache, group, obj)
    if url then
        self._callbacks[url] = obj;
        self._loader:load(url, type, cache);
    end
    return self
end

c.instance = c.new();

return c;