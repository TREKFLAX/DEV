local cache = nil
local fallback = nil

local function loadFile(lang)
    if type(lang) ~= 'string' or not lang:match('^[a-zA-Z][a-zA-Z0-9_-]*$') then
        return nil
    end
    local content = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not content then return nil end
    local ok, decoded = pcall(json.decode, content)
    if not ok or type(decoded) ~= 'table' then return nil end
    return decoded
end

local function ensureLoaded()
    if cache ~= nil then return end

    local lang = (Config and Config.Locale) or 'en'
    Locale = lang

    fallback = loadFile('en') or {}
    if lang == 'en' then
        cache = fallback
    else
        cache = loadFile(lang) or fallback
    end
end

local function resolve(tbl, key)
    if type(tbl) ~= 'table' then return nil end
    local node = tbl
    for part in string.gmatch(key, '[^%.]+') do
        if type(node) ~= 'table' then return nil end
        node = node[part]
    end
    if type(node) == 'string' then return node end
    return nil
end

function _L(key, ...)
    if type(key) ~= 'string' then return key end
    ensureLoaded()

    local str = resolve(cache, key) or resolve(fallback, key)
    if not str then
        return key
    end

    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, str, ...)
        if ok then return formatted end
    end

    return str
end

Locale = (Config and Config.Locale) or 'en'
