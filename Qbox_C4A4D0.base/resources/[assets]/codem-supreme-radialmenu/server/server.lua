local function loadLocaleFromDisk(requestedLocale)
    local locale = requestedLocale
    if type(locale) ~= 'string' or not locale:match("^[a-zA-Z][a-zA-Z0-9_-]*$") then
        locale = "en"
    end

    local resource = GetCurrentResourceName()
    local content = LoadResourceFile(resource, 'locales/' .. locale .. '.json')
    if not content then
        print(('[codem-radialmenu] locales/%s.json not found, falling back to "en"'):format(locale))
        locale = "en"
        content = LoadResourceFile(resource, 'locales/en.json')
    end

    if not content then
        print('[codem-radialmenu] locales/en.json missing on server, cannot serve locale')
        return nil
    end

    local ok, messages = pcall(json.decode, content)
    if not ok or type(messages) ~= 'table' then
        print(('[codem-radialmenu] failed to parse locales/%s.json'):format(locale))
        return nil
    end

    return { locale = locale, messages = messages }
end

if Framework.Type == 'qbx' then
    lib.callback.register('codem-radialmenu:server:getLocale', function(source, requestedLocale)
        return loadLocaleFromDisk(requestedLocale)
    end)
elseif Framework.Type == 'qbcore' then
    Framework.Object.Functions.CreateCallback('codem-radialmenu:server:getLocale', function(source, cb, requestedLocale)
        cb(loadLocaleFromDisk(requestedLocale))
    end)
else
    RegisterNetEvent('codem-radialmenu:server:getLocale', function(requestedLocale)
        local src = source
        TriggerClientEvent('codem-radialmenu:client:getLocaleResult', src, loadLocaleFromDisk(requestedLocale))
    end)
end
