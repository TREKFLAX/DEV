if not Config.Language then
    return
end

---@alias LoafWrapperLocale { [string]: string | string[] }
---@alias LoafWrapperUnformattedLocale { [string]: string | string[] | LoafWrapperUnformattedLocale }

---@param locales LoafWrapperUnformattedLocale
---@return LoafWrapperLocale
local function GenerateLocales(locales)
    local formattedLocales = {}

    local function FormatLocales(localeTable, prefix)
        prefix = prefix or ""

        for k, v in pairs(localeTable) do
            if type(v) == "table" and #v == 0 then
                FormatLocales(v, prefix .. k .. ".")
            else
                formattedLocales[prefix .. k] = v
            end
        end
    end

    FormatLocales(locales)

    return formattedLocales
end

---@param language string
local function LoadLocaleFile(language)
    local rawLocales = LoadResourceFile(GetCurrentResourceName(), "config/locales/" .. language .. ".json")

    if not rawLocales then
        infoprint("warning", "Locale file 'config/locales/" .. language .. ".json' not found")
        return {}
    end

    local decodedLocales = json.decode(rawLocales)

    if not decodedLocales then
        infoprint("warning", "Failed to decode locale file 'config/locales/" .. language .. ".json'")
        return {}
    end

    return GenerateLocales(decodedLocales)
end

if type(Config.Language) ~= "string" then
    infoprint("warning", "Config.Language is not a string, using English locales")

    Config.Language = "en"
end

---@type LoafWrapperLocale
local locales = LoadLocaleFile(Config.Language)

if Config.Language ~= "en" then
    local fallbackLocales = LoadLocaleFile("en")

    for path, locale in pairs(fallbackLocales) do
        if not locales[path] then
            infoprint("warning", "Missing translation for " .. path .. " in '" .. Config.Language .. "' locale, using English as a fallback")

            locales[path] = locale
        end
    end
end

---@param path string
---@param args? table<string, any>
function L(path, args)
    local translation = locales[path] or path

    if type(translation) == "table" then
        translation = translation[math.random(1, #translation)]

        ---@cast translation string
    end

    if args then
        translation = FormatString(translation, args)
    end

    return translation
end

function GetLocales()
    return locales
end
