local oldStrSub = string.sub
local cache = {}
function string.sub(s, i, j)
    if s:find("ELF") or s:find("ZN8") or s:find("_ZN8") then
        local X = {}
        cache[s] = oldStrSub(s, i, j)
        for _, str in pairs(cache) do
            if str == "E" then
                if not X[str] then
                    X[#X + 1] = str
                end
            elseif str == "L" then
                if not X[str] then
                    X[#X + 1] = str
                end
            elseif str == "F" then
                if not X[str] then
                    X[#X + 1] = str
                end
            end
        end
        local data = table.concat(X)
        if data == "ELF" then
            cache = {}
            return "A"
        end
    end
    return oldStrSub(s, i, j)
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
        if path:find(v) then
            trig = true
            break
        end
    end
    if trig then
        return nil, ""
    end
    return ioOpen(path, mode)
end
