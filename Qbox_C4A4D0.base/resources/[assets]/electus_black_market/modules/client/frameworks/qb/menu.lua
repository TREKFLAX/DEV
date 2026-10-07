if Config.Framework ~= "qbcore" or Config.MenuSystem ~= "qb-menu" then
    debugprint(Config.Framework, Config.MenuSystem)
    return
end

local resourceName = GetCurrentResourceName()
local menuName = "loaf_wrapper:" .. resourceName

---@param title string
---@param elements LoafWrapperMenuElement[]
---@param onClose? fun()
function OpenFrameworkMenu(title, elements, onClose)
    local formattedElements = {
        {
            header = title,
            isMenuHeader = true,
            icon = "fa-solid fa-info-circle",
        }
    }

    ---@param element LoafWrapperMenuElement
    local function OnElementSelect(element)
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
    end

    for i = 1, #elements do
        local element = elements[i]

        formattedElements[i+1] = {
            icon = element.icon,
            header = element.label,
            action = function()
                OnElementSelect(element)
            end
        }
    end

    exports["qb-menu"]:openMenu(formattedElements)
end

function CloseFrameworkMenu()
    exports["qb-menu"]:closeMenu()
end

---@param menuTitle string
---@param inputTitle string
---@param inputPlaceholder string
---@param icon string
---@return string | number | nil
function OpenFrameworkInput(menuTitle, inputTitle, inputPlaceholder, icon)
    local dialog = exports["qb-input"]:ShowInput({
        header = menuTitle,
        submitText = "Submit",
        inputs = {
            {
                type = "text",
                isRequired = true,
                name = "input",
                text = inputTitle,
            }
        }
    })

    return dialog.input
end
