local LastEquipped = {}

local ClothingComponents = {
    hair = { component = 2, label = _L('game.clothing.hair') },
    mask = { component = 1, label = _L('game.clothing.mask') },
    top = { component = 11, label = _L('game.clothing.top') },
    gloves = { component = 3, label = _L('game.clothing.gloves') },
    vest = { component = 9, label = _L('game.clothing.vest') },
    bag = { component = 5, label = _L('game.clothing.bag') },
    shoes = { component = 6, label = _L('game.clothing.shoes') },
    pants = { component = 4, label = _L('game.clothing.pants') },
    shirt = { component = 8, label = _L('game.clothing.shirt') },
    neck = { component = 7, label = _L('game.clothing.neck') }
}

local PropComponents = {
    hat = { prop = 0, label = _L('game.clothing.hat') },
    glasses = { prop = 1, label = _L('game.clothing.glasses') },
    ear = { prop = 2, label = _L('game.clothing.ear') },
    watch = { prop = 6, label = _L('game.clothing.watch') },
    bracelet = { prop = 7, label = _L('game.clothing.bracelet') }
}

RegisterNetEvent('codem-radialmenu:client:ToggleClothing', function(data)
    local ped = PlayerPedId()
    local componentName = data.component

    if not componentName then return end

    local clothingData = ClothingComponents[componentName]
    if not clothingData then
        Framework:Notify(nil, _L('game.notify.invalid_clothing'), 'error')
        return
    end

    local component = clothingData.component

    local currentDrawable = GetPedDrawableVariation(ped, component)
    local currentTexture = GetPedTextureVariation(ped, component)

    if LastEquipped[componentName] then
        local gender = GetPedType(ped) == 4 and 'male' or 'female'
        local defaultDrawable = gender == 'male' and 0 or 0
        local defaultTexture = 0

        if componentName == 'top' then
            defaultDrawable = gender == 'male' and 15 or 15
        elseif componentName == 'pants' then
            defaultDrawable = gender == 'male' and 14 or 14
        elseif componentName == 'shoes' then
            defaultDrawable = gender == 'male' and 34 or 35
        end

        SetPedComponentVariation(ped, component, defaultDrawable, defaultTexture, 0)
        LastEquipped[componentName] = nil

        Framework:Notify(nil, _L('game.notify.item_removed', clothingData.label), 'success')
    else
        LastEquipped[componentName] = {
            drawable = currentDrawable,
            texture = currentTexture
        }

        Framework:Notify(nil, _L('game.notify.item_equipped', clothingData.label), 'success')
    end
end)

RegisterNetEvent('codem-radialmenu:client:ToggleProp', function(data)
    local ped = PlayerPedId()
    local componentName = data.component

    if not componentName then return end

    local propData = PropComponents[componentName]
    if not propData then
        Framework:Notify(nil, _L('game.notify.invalid_prop'), 'error')
        return
    end

    local prop = propData.prop

    local currentProp = GetPedPropIndex(ped, prop)
    local currentTexture = GetPedPropTextureIndex(ped, prop)

    if currentProp ~= -1 and LastEquipped[componentName] then
        ClearPedProp(ped, prop)
        LastEquipped[componentName] = nil

        Framework:Notify(nil, _L('game.notify.item_removed', propData.label), 'success')
    else
        if currentProp ~= -1 then
            LastEquipped[componentName] = {
                prop = currentProp,
                texture = currentTexture
            }

            Framework:Notify(nil, _L('game.notify.item_equipped', propData.label), 'success')
        else
            Framework:Notify(nil, _L('game.notify.nothing_to_toggle', propData.label), 'error')
        end
    end
end)
