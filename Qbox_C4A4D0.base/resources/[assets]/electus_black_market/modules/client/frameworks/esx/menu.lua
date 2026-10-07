if Config.Framework ~= "esx" or (Config.MenuSystem ~= "esx_context" and Config.MenuSystem ~= "esx_menu_default") then
    return
end

local resourceName = GetCurrentResourceName()
local menuName = "loaf_wrapper:" .. resourceName

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
local function OpenDefaultMenu(title, elements, onClose)
    local formattedElements = {}

    for i = 1, #elements do
        local element = elements[i]

        formattedElements[i] = {
            label = element.label,
            value = i
        }
    end

    ESX.UI.Menu.Open("default", resourceName, menuName .. GetGameTimer(), {
        title = title,
        align = "top-left",
        elements = formattedElements,
    }, function(data, menu)
        menu.close()

        local element = elements[data.current.value]

        if not element.options then
            element:action()

            if onClose then
                onClose()
            end

            return
        end

        local nestedElements = {}

        for i = 1, #element.options do
            local option = element.options[i]

            nestedElements[i] = {
                label = option,
                action = function()
                    element:action(i)
                end
            }
        end

        OpenFrameworkMenu(element.label, nestedElements, function()
            OpenFrameworkMenu(title, elements, onClose)
        end)
    end, function(data, menu)
        menu.close()

        if onClose then
            onClose()
        end
    end)
end

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
local function OpenContextMenu(title, elements, onClose)
    local formattedElements = {
        {
            title = title,
            icon = "fa-solid fa-info-circle",
            unselectable = true,
        }
    }

    for i = 1, #elements do
        local element = elements[i]

        formattedElements[i+1] = {
            icon = element.icon,
            title = element.label,
            value = i
        }
    end

    ESX.OpenContext("right", formattedElements, function(menu, data)
        ESX.CloseContext()

        local element = elements[data.value]

        if not element.options then
            element:action()

            if onClose then
                onClose()
            end

            return
        end

        local nestedOptions = {}

        for j = 1, #element.options do
            local nestedOption = element.options[j]

            nestedOptions[#nestedOptions + 1] = {
                label = nestedOption,
                action = function()
                    element:action(j)
                end,
            }
        end

        OpenFrameworkMenu(element.label, nestedOptions, function()
            OpenFrameworkMenu(title, elements, onClose)
        end)
    end)
end

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
function OpenFrameworkMenu(title, elements, onClose)
    if Config.MenuSystem == "esx_menu_default" then
        OpenDefaultMenu(title, elements, onClose)
    elseif Config.MenuSystem == "esx_context" then
        OpenContextMenu(title, elements, onClose)
    end
end

function CloseFrameworkMenu()
    if Config.MenuSystem == "esx_menu_default" then
        ESX.UI.Menu.CloseAll()
    elseif Config.MenuSystem == "esx_context" then
        ESX.CloseContext()
    end
end

---@param menuTitle string
---@param inputTitle string
---@param inputPlaceholder string
---@return string | number | nil
local function OpenDialogMenu(menuTitle, inputTitle, inputPlaceholder)
    local dialogPromise = promise.new()

    ESX.UI.Menu.Open("dialog", resourceName, menuName .. GetGameTimer(), {
        title = menuTitle
    }, function(data, menu)
        dialogPromise:resolve(data.value)

        menu.close()
    end, function(data, menu)
        dialogPromise:resolve()

        menu.close()
    end)

    return Citizen.Await(dialogPromise)
end

---@param menuTitle string
---@param inputTitle string
---@param inputPlaceholder string
---@param icon string
---@return string | nil
local function OpenContextInput(menuTitle, inputTitle, inputPlaceholder, icon)
    local dialogPromise = promise.new()

    ESX.OpenContext("right", {
        {
            title = menuTitle,
            icon = "fa-solid fa-info-circle",
            unselectable = true,
        },
        {
            icon = icon,
            title = menuTitle,
            input = true,
            inputType = "text",
            inputPlaceholder = inputPlaceholder,
        },
        {
            icon = "fas fa-check",
            title = "Submit",
            name = "submit",
        },
    }, function(menu, data)
        dialogPromise:resolve(menu.eles[2].inputValue)

        ESX.CloseContext()
    end, function()
        dialogPromise:resolve()
    end)

    return Citizen.Await(dialogPromise)
end

---@param menuTitle string
---@param inputTitle string
---@param inputPlaceholder string
---@param icon string
---@return string | number | nil
function OpenFrameworkInput(menuTitle, inputTitle, inputPlaceholder, icon)
    if Config.MenuSystem == "esx_menu_default" then
        return OpenDialogMenu(menuTitle, inputTitle, inputPlaceholder)
    elseif Config.MenuSystem == "esx_context" then
        return OpenContextInput(menuTitle, inputTitle, inputPlaceholder, icon)
    end
end
