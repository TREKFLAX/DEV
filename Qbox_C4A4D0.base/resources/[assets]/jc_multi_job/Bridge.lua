function debugPrint(...)
    if Config.Debug then
        print("[DEBUG]", ...)
    end
end

function Tr(key, ...)
    local lang = (Config and Config.Locale) or "en"
    local str = (Locale and Locale[lang] and Locale[lang][key])
        or (Locale and Locale["en"] and Locale["en"][key])
        or key
    if select("#", ...) > 0 then
        return string.format(str, ...)
    end
    return str
end

function detectFramework()
    local fw = string.lower(Config.Framework or "auto")

    if fw == "esx" or fw == "qb" or fw == "standalone" then
        return fw
    end

    if GetResourceState("es_extended") == "started" then
        return "esx"
    end

    if GetResourceState("qb-core") == "started" then
        return "qb"
    end

    if GetResourceState("qbx_core") == "started" then
        return "qb"
    end

    return "standalone"
end

Config.Framework = detectFramework()

if Config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "qb" then
    if GetResourceState("qb-core") == "started" then
        QBCore = exports["qb-core"]:GetCoreObject()
    end
end

if IsDuplicityVersion() then
    CreateThread(function()
        Wait(1500)
        local resName = GetCurrentResourceName()
        local version = GetResourceMetadata(resName, "Version", 0) or GetResourceMetadata(resName, "version", 0) or
            "1.0.01"
        local fw = (Config and Config.Framework) or "unknown"
        print("^2========================================^7")
        print("^2   Jota Dev Multijob^7 V" .. tostring(version))
        print("^2========================================^7")
        print("^3 Framework:^7 " .. tostring(fw))
        print("^2========================================^7")
    end)
end
