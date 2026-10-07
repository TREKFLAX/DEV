local _pi = math.pi

function RotationToDirection(rotation)
    local rx = (_pi / 180) * rotation.x
    local ry = (_pi / 180) * rotation.y
    local rz = (_pi / 180) * rotation.z
    local absCosX = math.abs(math.cos(rx))
    return vector3(
        -math.sin(rz) * absCosX,
         math.cos(rz) * absCosX,
         math.sin(rx)
    )
end

function CameraRaycast(flags)
    flags = flags or 1
    local camRot   = GetGameplayCamRot()
    local camCoord = GetGameplayCamCoord()
    local dir      = RotationToDirection(camRot)
    local dest     = camCoord + (dir * 10.0)

    local ray = StartShapeTestRay(
        camCoord.x, camCoord.y, camCoord.z,
        dest.x,     dest.y,     dest.z,
        flags, PlayerPedId(), 0
    )
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
    return hit, endCoords, surfaceNormal, entityHit
end

function DebugPrint(...)
    if Config and Config.Debug then
        print(...)
    end
end

---@param point vector3|table
---@return vector3|nil
local function resolveCoords(point)
    if type(point) == 'vector3' then
        return point
    end

    if type(point) == 'table' then
        local x = point.x or point[1]
        local y = point.y or point[2]
        local z = point.z or point[3]
        if x and y and z then
            return vector3(x, y, z)
        end
    end

    return nil
end

--- Returns true when coords are within a configured duty point (wardrobe spot).
--- Checks per-station dutyPoints first, then optional global Locker.dutyPoints.
---@param coords vector3
---@return boolean
function IsNearLockerDutyPoint(coords)
    if not Config then return false end

    local lockerCfg = Config.Locker or {}
    local defaultRadius = lockerCfg.distance or 1.5
    local stationProximity = lockerCfg.stationProximityRadius or 500.0

    for _, station in pairs(Config.Stations or {}) do
        local points = station.dutyPoints
        if points and #points > 0 and station.coords and #(coords - station.coords) <= stationProximity then
            local pointRadius = station.dutyPointRadius or defaultRadius

            for _, point in ipairs(points) do
                local pt = resolveCoords(point)
                if pt and #(coords - pt) <= pointRadius then
                    return true
                end
            end
        end
    end

    local globalPoints = lockerCfg.dutyPoints
    if globalPoints and #globalPoints > 0 then
        local pointRadius = lockerCfg.dutyPointRadius or defaultRadius
        if not IsNearAnyFireStation(coords, stationProximity) then
            return false
        end

        for _, point in ipairs(globalPoints) do
            local pt = resolveCoords(point)
            if pt and #(coords - pt) <= pointRadius then
                return true
            end
        end
    end

    return false
end

--- Returns every configured duty point within maxDist of coords, using the same
--- station-proximity rules as IsNearLockerDutyPoint. Used to draw the "clock in
--- here" markers, so it looks further out than the interaction radius.
---@param coords vector3
---@param maxDist number
---@return vector3[]
function GetNearbyLockerDutyPoints(coords, maxDist)
    local found = {}
    if not Config then return found end

    local lockerCfg = Config.Locker or {}
    local stationProximity = lockerCfg.stationProximityRadius or 500.0

    for _, station in pairs(Config.Stations or {}) do
        local points = station.dutyPoints
        if points and #points > 0 and station.coords and #(coords - station.coords) <= stationProximity then
            for _, point in ipairs(points) do
                local pt = resolveCoords(point)
                if pt and #(coords - pt) <= maxDist then
                    found[#found + 1] = pt
                end
            end
        end
    end

    local globalPoints = lockerCfg.dutyPoints
    if globalPoints and #globalPoints > 0 and IsNearAnyFireStation(coords, stationProximity) then
        for _, point in ipairs(globalPoints) do
            local pt = resolveCoords(point)
            if pt and #(coords - pt) <= maxDist then
                found[#found + 1] = pt
            end
        end
    end

    return found
end

--- Returns true when the player can use the locker (prop or duty point) at a fire station.
---@param coords vector3
---@return boolean
function IsNearLockerInteraction(coords)
    if not IsNearAnyFireStation(coords) then
        return false
    end

    if IsNearLockerDutyPoint(coords) then
        return true
    end

    local lockerCfg = Config.Locker or {}
    local propHash = lockerCfg.propHash or 2200060172
    local distance = lockerCfg.distance or 1.5

    local locker = GetClosestObjectOfType(
        coords.x, coords.y, coords.z,
        distance,
        propHash,
        false, false, false
    )

    return locker ~= 0
end

--- Returns true when coords are within maxDist of any configured fire station.
---@param coords vector3
---@param maxDist number|nil
---@return boolean
function IsNearAnyFireStation(coords, maxDist)
    if not Config or not Config.Stations then return false end

    local lockerCfg = Config.Locker or {}
    local radius = maxDist or lockerCfg.stationProximityRadius or 500.0

    for _, station in pairs(Config.Stations) do
        if station.coords and #(coords - station.coords) <= radius then
            return true
        end
    end

    return false
end