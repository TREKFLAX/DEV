local function ConcatPrint(...)
    local data = { ... }
    local str = ""

    for i = 1, #data do
        if type(data[i]) == "table" then
            str = str .. json.encode(data[i], {
                indent = true,
                sort_keys = true,
                exception = function(reason, value)
                    return tostring(value)
                end,
            })
        elseif type(data[i]) ~= "string" then
            str = str .. tostring(data[i])
        else
            str = str .. data[i]
        end

        if i ~= #data then
            str = str .. " "
        end
    end

    return str
end

function debugprint(...)
    if not Config.Debug then
        return
    end

    print("^3[Debug]^7: " .. ConcatPrint(...), "^7")
end

local infoLevels = {
    success = "^2[SUCCESS]",
    info = "^5[INFO]",
    warning = "^3[WARNING]",
    error = "^1[ERROR]",
}

---@param level "success" | "info" | "warning" | "error"
function infoprint(level, ...)
    local prefix = infoLevels[level]

    if not prefix then
        prefix = "^5[INFO]^7:"
    end

    print(prefix .. "^7: " .. ConcatPrint(...), "^7")
end

---@param t table
---@return number
function GenerateUniqueKey(t)
    local id = math.random(999999999)

    while t[id] do
        id = math.random(999999999)
    end

    return id
end

---@param array any[]
---@param value any
---@return boolean
function table.contains(array, value)
    for i = 1, #array do
        if array[i] == value then
            return true
        end
    end

    return false
end

---@param array1 any[]
---@param array2 any[]
function table.combine(array1, array2)
    for i = 1, #array2 do
        array1[#array1 + 1] = array2[i]
    end

    return array1
end

---@param value number
---@param min number
---@param max number
---@return number
function math.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end

    return value
end

---@param value number
---@param decimals number
function math.round(value, decimals)
    if not value or type(value) ~= "number" then
        return 0
    end

    if not decimals or type(decimals) ~= "number" or decimals == 0 then
        return math.floor(value + 0.5)
    end

    local mult = 10 ^ (decimals or 0)

    return math.floor(value * mult + 0.5) / mult
end

---@param input string
---@param variables table<string, any>
function FormatString(input, variables)
    assert(type(input) == "string", "input must be a string")
    assert(type(variables) == "table", "variables must be a table")

    for k, v in pairs(variables) do
        local safeValue = tostring(v):gsub("%%", "%%%%")

        input = input:gsub("{" .. k .. "}", safeValue)
    end

    return input
end

---@param value any
function IsFunction(value)
    local valueType = type(value)

    if valueType == "function" then
        return true
    elseif valueType == "table" and type(getmetatable(value)?.__call) == "function" then
        return true
    end

    return false
end
