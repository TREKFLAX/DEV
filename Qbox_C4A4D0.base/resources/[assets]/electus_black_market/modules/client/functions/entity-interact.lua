---@class LoafWrapperEntityInteractOptions
---@field entity? number
---@field model? string | number
---@field name string
---@field options LoafWrapperInteractOption[]

---@class LoafWrapperEntityInteract : LoafWrapperEntityInteractOptions
---@field remove fun(self: LoafWrapperEntityInteract)

---@type { [number]: LoafWrapperEntityInteract[] }
local interactEntities = {}
---@type { [number]: LoafWrapperEntityInteract[] }
local interactModels = {}
---@type { [number]: number }
local modelSizes = {}
---@type { [number]: number[] }
local modelEntities = {}

---@param options LoafWrapperInteractOption[]
---@param entity number
local function OpenInteractMenu(options, entity)
    ---@type LoafWrapperMenuElement[]
    local menuElements = {}

    for i = 1, #options do
        local option = options[i]

        if option.canInteract and not option.canInteract() then
            goto continue
        end

        menuElements[#menuElements + 1] = {
            label = option.label,
            icon = option.icon,
            canInteract = option.canInteract,
            action = function()
                option.action(entity)
            end,
        }

        ::continue::
    end

    if #menuElements == 0 then
        return
    end

    OpenMenu("Interact", menuElements)
end

---@param options LoafWrapperInteractOption[]
---@return boolean
local function CanInteractWithAnyAction(options)
    for i = 1, #options do
        local option = options[i]

        if not option.canInteract or option.canInteract() then
            return true
        end
    end

    return false
end

local currentEntity = nil

---@param entity? number
---@param model? number
---@return number
local function GetModelSize(entity, model)
    if entity and not model then
        model = GetEntityModel(entity)
    end

    if model and not modelSizes[model] then
        local min, max = GetModelDimensions(model)

        modelSizes[model] = math.max(max.x, max.y) + 0.75
    end

    return model and modelSizes[model] or 3.0
end

---@param entity number
---@param options LoafWrapperEntityInteract[]
local function OnEnterInteract(entity, options)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local entityCoords = GetEntityCoords(entity)
    local size = GetModelSize(entity)

    currentEntity = entity

    DrawHelpText(
        "Interact",
        51,
        "~INPUT_CONTEXT~"
    )

    while #(entityCoords - playerCoords) <= size do
        Wait(0)

        entityCoords = GetEntityCoords(entity)
        playerCoords = GetEntityCoords(PlayerPedId())

        if not DoesEntityExist(entity) then
            break
        end

        if IsControlJustReleased(0, 51) then
            OpenInteractMenu(options, entity)
        end
    end

    ClearHelpText()

    currentEntity = nil
end

local refreshEntitiesInterval = Interval:new(function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    ---@type { [number]: number[] }
    local newModelEntities = {}

    -- TODO: does CObject contain entities from CNetObject?
    for _, poolName in pairs({ "CPed", "CObject", "CVehicle" }) do
        local pool = GetGamePool(poolName)

        for i = 1, #pool do
            local entity = pool[i]
            local model = GetEntityModel(entity)
            local entityCoords = GetEntityCoords(entity)

            if #(entityCoords - playerCoords) > 250.0 then
                goto continue
            end

            if not newModelEntities[model] then
                newModelEntities[model] = {}
            end

            table.insert(newModelEntities[model], entity)

            ::continue::
        end
    end

    modelEntities = newModelEntities
end, 5000, false)

local entityInteractInterval = Interval:new(function()
    local playerCoords = GetEntityCoords(PlayerPedId())

    if currentEntity then
        return
    end

    for model, options in pairs(interactModels) do
        local entities = modelEntities[model]

        if not entities then
            goto continue
        end

        local size = GetModelSize(nil, model)

        for i = 1, #entities do
            local entity = entities[i]
            local entityCoords = GetEntityCoords(entity)

            if #(entityCoords - playerCoords) <= size and CanInteractWithAnyAction(options) then
                OnEnterInteract(entity, options)
            end
        end

        ::continue::
    end

    for entity, options in pairs(interactEntities) do
        local size = GetModelSize(entity)
        local entityCoords = GetEntityCoords(entity)

        if #(entityCoords - playerCoords) <= size and CanInteractWithAnyAction(options) then
            OnEnterInteract(entity, options)
        end
    end
end, 100, false)

---@param interactPoint LoafWrapperEntityInteract
local function RemoveEntityInteractPoint(interactPoint)
    if Config.Target then
        ---@type string[]
        local labels = {}

        for i = 1, #interactPoint.options do
            labels[i] = interactPoint.options[i].label
        end

        if interactPoint.model then
            exports.qtarget:RemoveTargetModel({ interactPoint.model }, labels)
        end

        if interactPoint.entity then
            exports.qtarget:RemoveTargetEntity({ interactPoint.entity }, labels)
        end

        return
    end

    if interactPoint.model then
        interactModels[interactPoint.model] = nil
    end

    if interactPoint.entity then
        interactEntities[interactPoint.entity] = nil
    end

    if not next(interactModels) and not next(interactEntities) then
        refreshEntitiesInterval:toggle(false)
        entityInteractInterval:toggle(false)
    end
end

---@param options LoafWrapperEntityInteractOptions
---@return LoafWrapperEntityInteract
function AddEntityInteractPoint(options)
    ---@cast options LoafWrapperEntityInteract

    if type(options.model) == "string" then
        options.model = joaat(options.model)
    end

    if Config.Target then
        if options.model then
            exports.qtarget:AddTargetModel({ options.model }, {
                options = options.options,
                distance = 2.0
            })
        end

        if options.entity then
            exports.qtarget:AddTargetEntity({ options.entity }, {
                options = options.options,
                distance = 2.0
            })
        end

        options.remove = RemoveEntityInteractPoint
    else
        if options.entity then
            if not interactEntities[options.entity] then
                interactEntities[options.entity] = {}
            end

            table.combine(interactEntities[options.entity], options.options)
        end

        if options.model then
            if not interactModels[options.model] then
                interactModels[options.model] = {}
            end

            table.combine(interactModels[options.model], options.options)
        end

        refreshEntitiesInterval:toggle(true)
        entityInteractInterval:toggle(true)
    end

    return options
end
