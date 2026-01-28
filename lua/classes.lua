local tof = function(Val)
    local function inner(val)
        local c = type(val)
        if (c == "function") then
            return ("f")
        elseif (c == "table") then
            return ("t")
        elseif (c == "boolean") then
            return ("bl")
        elseif (c == "nil") then
            return ("n")
        elseif (c == "userdata") then
            return ("u")
        elseif (c == "string") then
            return ("s")
        end
        return "unkownType"
    end
    local cls = {}
    cls.value = inner(Val)
    return cls.value
end

local createClass = function()
    local cs = {}
    return cs
end

local ACF = function(t, fn, fv)
    if not t then
        return
    end
    local b = tof(fn)
    local c = tof(fv)
    if b ~= "s" then
        return
    end
    if c ~= "f" then
        return
    end
    if not t.rg then
        t.rg = {}
    end
    t.rg[fn] = function(self)
        local succ, err = pcall(fv)
        if not succ then
            print("err")
            return
        end
    end
end
-------------------------------------------------------

local BasePlayer = BasePlayer
if not BasePlayer then
    BasePlayer = createClass()
end

ACF(
    BasePlayer,
    "getHeight",
    function()
        return 1.8
    end
)
ACF(
    BasePlayer,
    "getWidth",
    function()
        return 0.6
    end
)
ACF(
    BasePlayer,
    "getLength",
    function()
        return 0.6
    end
)
