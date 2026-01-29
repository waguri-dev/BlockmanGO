local oldStrSub = string.sub
local cache = {}
function string.sub(s, i, j)
    if s:find("ELF") or s:find("ZN8") or s:find("_ZN8") then
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end
    return oldStrSub(s, i, j)
end

local function strip(str)
    local b = {
        "_",
        "/",
        "\\",
        "//"
    }
    for i, v in pairs(b) do
        str = str:gsub(v, "")
    end
    return str
end

local ioOpen = io.open
function io.open(path, mode)
    local trig = false
    for i, v in pairs(
        {
            "proc/self/maps",
            "proc/self/mem",
            "%.dll$",
            "%.so$"
        }
    ) do
        if path:match(v) or strip(path):match(strip(v)) then
            trig = true
            break
        end
    end
    if trig then
        return nil, ""
    end
    return ioOpen(path, mode)
end

if package.searchers[2] then
    local ch = {} 
    local lloader = package.searchers[2]
    package.searchers[2] = function(...)
        print("tryCallLoad, init var(isAC)")
        local isAC = false
        local args = {...}
        for _, arg in pairs(args) do
            if type(arg) == "string" then
                if arg:match("proc/self/maps") or arg:match("proc/self/mem") then
                    isAC = true
                end
            end
        end
        if isAC then
            return false
        end
        return lloader(table.unpack(args))
    end
