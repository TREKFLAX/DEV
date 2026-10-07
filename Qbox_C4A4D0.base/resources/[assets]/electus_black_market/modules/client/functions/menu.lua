---@class LoafWrapperMenuElement
---@field icon? string # https://fontawesome.com/search?ic=free
---@field label string
---@field options? string[]
---@field action fun(self: LoafWrapperMenuElement, selectedItem?: number)
---@field canInteract? fun(): boolean
---@field [string] any

local resourceName = GetCurrentResourceName()
local menuName = "loaf_wrapper:" .. resourceName

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
local function OpenOXLibMenu(title, elements, onClose)
    local menuOptions = {}

    for i = 1, #elements do
        local option = elements[i]

        menuOptions[#menuOptions + 1] = {
            icon = option.icon,
            label = option.label,
            values = option.options,
            args = {
                action = function(scrollIndex)
                    option:action(scrollIndex)

                    if onClose then
                        onClose()
                    end
                end,
            },
        }
    end

    exports.ox_lib:registerMenu({
        id = menuName,
        title = title,
        options = menuOptions,
        onClose = function()
            if onClose then
                onClose()
            end
        end,
    }, function(selected, scrollIndex, args)
        args.action(scrollIndex)
    end)

    exports.ox_lib:showMenu(menuName)
end

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
local function OpenOXLibContextMenu(title, elements, onClose)
    local menuOptions = {}

    for i = 1, #elements do
        local option = elements[i]

        menuOptions[#menuOptions + 1] = {
            icon = option.icon,
            title = option.label,
            onSelect = function()
                if not option.options then
                    option:action()

                    if onClose then
                        onClose()
                    end

                    return
                end

                local nestedOptions = {}

                for j = 1, #option.options do
                    local nestedOption = option.options[j]

                    nestedOptions[#nestedOptions + 1] = {
                        label = nestedOption,
                        action = function()
                            option:action(j)
                        end,
                    }
                end

                OpenMenu(option.label, nestedOptions, function()
                    SetTimeout(50, function()
                        OpenMenu(title, elements, onClose)
                    end)
                end)
            end,
        }
    end

    exports.ox_lib:registerContext({
        id = menuName,
        title = title,
        options = menuOptions,
        onExit = function()
            if onClose then
                onClose()
            end
        end,
    })

    exports.ox_lib:showContext(menuName)
end

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
function OpenMenu(title, elements, onClose)
    ---@type LoafWrapperMenuElement[]
    local cleanedElements = {}

    for i = 1, #elements do
        local element = elements[i]

        if not element.canInteract or element.canInteract() then
            cleanedElements[#cleanedElements + 1] = element
        end
    end

    if Config.MenuSystem == "ox_lib_menu" then
        OpenOXLibMenu(title, cleanedElements, onClose)
    elseif Config.MenuSystem == "ox_lib_context" then
        OpenOXLibContextMenu(title, cleanedElements, onClose)
    else
        OpenFrameworkMenu(title, cleanedElements, onClose)
    end
end

function CloseMenu()
    if Config.MenuSystem == "ox_lib_menu" then
        exports.ox_lib:hideMenu()
    elseif Config.MenuSystem == "ox_lib_context" then
        exports.ox_lib:hideContext()
    else
        CloseFrameworkMenu()
    end
end

---@param menuTitle string
---@param inputTitle? string
---@param inputPlaceholder? string
---@param icon? string
---@return string | number | nil
function OpenInput(menuTitle, inputTitle, inputPlaceholder, icon)
    inputTitle = inputTitle or ""
    inputPlaceholder = inputPlaceholder or ""
    icon = icon or "fa-solid fa-keyboard"

    if Config.MenuSystem == "ox_lib_menu" or Config.MenuSystem == "ox_lib_context" then
        local input = exports.ox_lib:inputDialog(menuTitle, {
            {
                type = "input",
                label = inputTitle,
                icon = icon,
                default = inputPlaceholder,
                required = true,
            },
        })

        return input and input[1]
    else
        return OpenFrameworkInput(menuTitle, inputTitle, inputPlaceholder, icon)
    end
end
