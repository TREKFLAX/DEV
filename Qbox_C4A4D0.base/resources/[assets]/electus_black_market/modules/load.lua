local sharedFiles = {
    "shared/default-config.lua",
    "shared/functions/functions.lua",
    "shared/functions/auto-detect.lua",
    "shared/functions/locales.lua",
    "shared/functions/interval.lua"
}

local serverFiles = {
    "server/callbacks/register-callbacks.lua",
    "server/frameworks/esx/esx.lua",
    "server/frameworks/esx/money.lua",
    "server/frameworks/qb/money.lua",
    "server/frameworks/qb/qb.lua",
    "server/frameworks/qbox/money.lua",
    "server/frameworks/qbox/qbox.lua",
    "server/frameworks/standalone/money.lua",
    "server/frameworks/standalone/standalone.lua",
    "server/inventories/core_inventory.lua",
    "server/inventories/esx.lua",
    "server/inventories/ox_inventory.lua",
    "server/inventories/qb-inventory.lua",
    "server/inventories/qs-inventory.lua",
    "server/inventories/tgiann-inventory.lua"
}

local clientFiles = {
    "client/callbacks/trigger-callbacks.lua",
    "client/frameworks/esx/items.lua",
    "client/frameworks/esx/menu.lua",
    "client/frameworks/qb/items.lua",
    "client/frameworks/qb/menu.lua",
    "client/frameworks/qbox/items.lua",
    "client/functions/buttons.lua",
    "client/functions/entity-interact.lua",
    "client/functions/functions.lua",
    "client/functions/help-text.lua",
    "client/functions/menu.lua"
}

local fileNamePrefix = "modules/"
local resourceToLoadFrom = GetCurrentResourceName()

local function LoadFiles(files)
    for i = 1, #files do
        local fileName = fileNamePrefix .. files[i]

        Citizen.CreateThreadNow(function()
            local fileContent = LoadResourceFile(resourceToLoadFrom, fileName)

            if not fileContent then
                print("^1[ERROR]^7: Failed to load module file '" .. fileName .. "'")
                return
            end

            local loadFunction, errorMessage = load(fileContent, "@@" .. resourceToLoadFrom .. "/" .. fileName)

            if loadFunction then
                pcall(loadFunction)
            else
                print("^1[ERROR]^7: Failed to load module file '" .. fileName .. "': " .. errorMessage)
            end
        end)
    end
end

LoadFiles(sharedFiles)

if IsDuplicityVersion() then
    LoadFiles(serverFiles)
else
    LoadFiles(clientFiles)
end
