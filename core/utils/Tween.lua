local class = require("class");
local EventDispatcher = require("node.modules.EventDispatcher");
local Ease = require("fairy.core.utils.Ease");

local linear = Ease.linear;

---@class Fairy_Core_Utils_Tween : Node_EventDispatcher
local tween = class(EventDispatcher);

local function performEasingOnSubject(subject, target, initial, clock, duration, easing)
    local t, b, c, d
    for k, v in pairs(target) do
        if type(v) == 'table' then
            performEasingOnSubject(subject[k], v, initial[k], clock, duration, easing)
        else
            t, b, c, d = clock, initial[k], v - initial[k], duration
            subject[k] = easing(t, b, c, d)
        end
    end
end

-- private stuff

local function copyTables(destination, keysTable, valuesTable)
    valuesTable = valuesTable or keysTable
    local mt = getmetatable(keysTable)
    if mt and getmetatable(destination) == nil then
        setmetatable(destination, mt)
    end
    for k, v in pairs(keysTable) do
        if type(v) == 'table' then
            destination[k] = copyTables({}, v, valuesTable[k])
        else
            destination[k] = valuesTable[k]
        end
    end
    return destination
end

function tween:ctor(target, props)
    EventDispatcher.ctor(self);

    self.target = target;
    ---@type {type:string,f:fun,c:any,d:number,o:table,p:table,a:any[],t:any,e:fun(),}[]
    self._steps = {};   -- 动作执行列表

    self.destroyed = false;
    self._time = 0;
    self._index = 1;
    self._duration = 0;

    self._count = 1;
    if props.loop then
        self._count = -1;
    end

end

---@param duration number
function tween:wait(duration)
    self:_addStep({ d = duration, type = "wait" });
    return self;
end

---@param props table
---@param duration number
---@param ease fun
function tween:to(props, duration, ease)
    duration = duration or 0;
    self:_addTween({ d = duration, e = ease or linear, p = props });
    return self;
end

-----@param props table
-----@param duration number
-----@param ease fun
--function tween:form(props, duration, ease)
--    local p = copyTables({}, props, self.target);
--    copyTables(self.target, props, props);
--    duration = duration or 0;
--    self:_addTween({ d = duration, e = ease or linear, p = p });
--    return self;
--end

---@param props
---@param target any
function tween:set(props, target)
    self:_addAction(self._set, self, { props, target and target or self.target });
    return self;
end

---@param func fun
---@param caller any
---@param args any[]
function tween:call(func, caller, args)
    self:_addAction(func, caller, args);
    return self;
end

--- 加入队列
function tween:remove()
    self:_addAction(self.destroy, self)
end

--- 立即停止 并去除
function tween:destroy()
    self.destroyed = true;
end

---@protected
function tween:_set(props, o)
    for n, _ in pairs(props) do
        o[n] = props[n];
    end
end

---@protected
function tween:update(dt)
    if self._count ~= 0 and not self.destroyed then
        self._time = self._time + dt;
        self:doStep(self._index, self._duration);
        if self._time >= self._duration then
            self._index = self._index + 1;
            if self._index > #self._steps then
                self._count = self._count - 1;
                if self._count == 0 then
                else
                    self._index = 1;
                end
            end
            self._time = self._time - self._duration;
            self:__updateStep();
            if self._time > 0 then
                self:update(0);
            end
        end
    end
end

---@protected
function tween:doStep(index)
    if self._steps[index] then
        local o = self._steps[index];
        if o.type == "action" then
            if o.c then
                o.f(o.c, unpack(o.a));
            else
                o.f(unpack(o.a));
            end
        elseif o.type == "step" then
            performEasingOnSubject(self.target, o.p, o.o, self._time, o.d, o.e);
        end
    end
end

---@protected
function tween:__updateStep()
    local o = self._steps[self._index];
    if o then
        self._duration = o.d or 0;
        if o.type == "step" then
            o.o = copyTables(o.o or {}, o.p, self.target);
        end
    end
end

---@protected
function tween:_addStep(o)
    if o.d then
        o.d = o.d / 1000;
    end
    table.insert(self._steps, o);
    if #self._steps == 1 then
        self:__updateStep();
    end
end

---@protected
---@param func fun
---@param caller any
---@param args any[]
function tween:_addAction(func, caller, args)
    self:_addStep({ type = "action", f = func, c = caller, a = args or {} });
end

---@protected
function tween:_addTween(o)
    if o.d > 0 then
        o.type = "step";
        self:_addStep(o);
    end
end

---@class Fairy_Core_Utils_TweenManager
local c = {};

---@type Fairy_Core_Utils_Tween[]
local _tweens = {};

---@param target any
---@param props {loop:boolean,override:boolean}
---@return Fairy_Core_Utils_Tween
function c.Get(target, props)
    props = props or {};
    if props.override then
        c.RemoveTweens(target);
    end
    local tw = tween.new(target, props);
    table.insert(_tweens, tw);
    return tw;
end

function c.RemoveAllTweens()
    for _, tw in ipairs(_tweens) do
        tw:destroy();
    end
end

function c.RemoveTweens(target)
    for _, tw in ipairs(_tweens) do
        if tw.target == target then
            tw:destroy();
        end
    end
end

---@protected
function c._UpdateAll(dt)
    if _tweens[1] then
        for i = #_tweens, 1, -1 do
            if (_tweens[i] == nil or _tweens[i].destroyed) then
                table.remove(_tweens, i);
            end
        end
        for _, timer in ipairs(_tweens) do
            if timer:update(dt) then
                timer:remove();
            end
        end

    end

end

return c;