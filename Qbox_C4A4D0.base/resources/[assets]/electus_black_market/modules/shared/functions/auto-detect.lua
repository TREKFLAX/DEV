---@param resource string
function IsResourceStartedOrStarting(resource)
    local state = GetResourceState(resource)

    return state == "started" or state == "starting"
end

if Config.Framework == "qb" or Config.Framework == "qb-core" then
    Config.Framework = "qbcore"
elseif Config.Framework == "es_extended" then
    Config.Framework = "esx"
elseif Config.Framework == "qbx" or Config.Framework == "qbx_core" then
    Config.Framework = "qbox"
end

if Config.Framework == "auto" or not Config.Framework then
    debugprint("Framework set to auto, or not set, detecting...")

    if IsResourceStartedOrStarting("es_extended") then
        Config.Framework = "esx"
    elseif IsResourceStartedOrStarting("qbx_core") then
        Config.Framework = "qbox"
    elseif IsResourceStartedOrStarting("qb-core") then
        Config.Framework = "qbcore"
    else
        Config.Framework = "custom"
    end

    debugprint("Detected framework: " .. Config.Framework)
end

if Config.Inventory == "auto" or not Config.Inventory then
    debugprint("Inventory set to auto, or not set, detecting...")

    local inventoryScripts = {
        "ox_inventory",
        "qb-inventory",
        "lj-inventory",
        "core_inventory",
        "mf-inventory",
        "qs-inventory",
        "codem-inventory",
        "ps-inventory",
    }

    for i = 1, #inventoryScripts do
        local scriptName = inventoryScripts[i]

        if IsResourceStartedOrStarting(scriptName) then
            Config.Inventory = scriptName
            debugprint("Detected inventory script:", scriptName)
            break
        end
    end
end

if Config.Garage == "auto" or not Config.Garage then
    local garageScripts = {
        "jg-advancedgarages"
    }

    debugprint("Garage set to auto, or not set, detecting...")

    for i = 1, #garageScripts do
        local scriptName = garageScripts[i]

        if IsResourceStartedOrStarting(scriptName) then
            Config.Garage = scriptName
            debugprint("Detected garage script:", scriptName)
            break
        end
    end

    if Config.Garage == "auto" then
        Config.Garage = "default"
        debugprint("No garage script detected, using default.")
    end
end

if Config.NotificationSystem == "auto" or not Config.NotificationSystem then
    if IsResourceStartedOrStarting("ox_lib") then
        Config.NotificationSystem = "ox_lib"
    else
        Config.NotificationSystem = "framework"
    end
end

if Config.MenuSystem == "auto" or not Config.MenuSystem then
    if IsResourceStartedOrStarting("ox_lib") then
        Config.MenuSystem = "ox_lib_context"
    elseif IsResourceStartedOrStarting("esx_context") then
        Config.MenuSystem = "esx_context"
    elseif IsResourceStartedOrStarting("esx_menu_default") then
        Config.MenuSystem = "esx_menu_default"
    elseif IsResourceStartedOrStarting("qb-menu") then
        Config.MenuSystem = "qb-menu"
    else
        infoprint("error", "[loaf_wrapper] No menu system detected.")
    end
end

if Config.Target == "auto" or Config.Target == nil then
    if IsResourceStartedOrStarting("qtarget") or IsResourceStartedOrStarting("qb-target") then
        Config.Target = true
    else
        Config.Target = false
    end
end

if Config.HelpTextStyle == "auto" or not Config.HelpTextStyle then
    local helpTextScripts = {
        "ox_lib",
        "okokTextUI",
        "jg-textui",
        "cd_drawtextui"
    }

    Config.HelpTextStyle = "gta"

    for i = 1, #helpTextScripts do
        local scriptName = helpTextScripts[i]

        if IsResourceStartedOrStarting(scriptName) then
            Config.HelpTextStyle = scriptName
            debugprint("Detected help text style:", scriptName)
            break
        end
    end
end

if Config.DispatchSystem == "auto" or not Config.DispatchSystem then
    if IsResourceStartedOrStarting("lb-tablet") then
        Config.DispatchSystem = "lb-tablet"
    elseif IsResourceStartedOrStarting("ps-dispatch") then
        Config.DispatchSystem = "ps-dispatch"
    elseif IsResourceStartedOrStarting("cd_dispatch") then
        Config.DispatchSystem = "cd_dispatch"
    elseif IsResourceStartedOrStarting("origen_police") then
        Config.DispatchSystem = "origen_police"
    elseif IsResourceStartedOrStarting("qs-dispatch") then
        Config.DispatchSystem = "qs-dispatch"
    end
end

if Config.CompanyMoneySystem == "auto" or not Config.CompanyMoneySystem then
    local companyMoneyScripts = {
        "esx_addonaccount",
        "qb-banking",
        "Renewed-Banking",
        "renewed-banking",
        "qb-management",
    }

    for i = 1, #companyMoneyScripts do
        local scriptName = companyMoneyScripts[i]

        if IsResourceStartedOrStarting(scriptName) then
            Config.CompanyMoneySystem = scriptName
            debugprint("Detected company money system:", scriptName)
            break
        end
    end

    if Config.CompanyMoneySystem == "auto" or not Config.CompanyMoneySystem then
        Config.CompanyMoneySystem = "template"
        infoprint("error", "[loaf_wrapper] No company money system detected, using template.")
    end
end
