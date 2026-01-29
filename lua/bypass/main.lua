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
        if path:find(v) or strip(path):find(strip(v)) then
            trig = true
            break
        end
    end
    if trig then
        return nil, ""
    end
    return ioOpen(path, mode)
end
