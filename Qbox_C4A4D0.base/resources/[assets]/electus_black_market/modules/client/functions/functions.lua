---@param dict string
---@param timeout? number # Timeout in milliseconds. Defaults to 5000ms.
---@return string dict
---@return boolean success
function LoadDict(dict, timeout)
	timeout = timeout or 5000

	RequestAnimDict(dict)

	local startTime = GetGameTimer()

	while not HasAnimDictLoaded(dict) do
		Wait(0)

		if timeout and GetGameTimer() - startTime > timeout then
			debugprint("LoadDict: Timed out loading dict:", dict, "after", timeout, "ms")
			return dict, false
		end
	end

	return dict, true
end

---@param model string | number
---@return number
function GetModelHash(model)
	if type(model) == "string" then
		return joaat(model)
	end

	return model
end

---@param model string | number
---@param timeout? number # Timeout in milliseconds. Defaults to 5000ms.
---@return number? model
function LoadModel(model, timeout)
	model = GetModelHash(model)
	timeout = timeout or 5000

	if not IsModelValid(model) then
		debugprint("LoadModel: Invalid model:", model)
		return
	end

	if not IsModelInCdimage(model) then
		debugprint("LoadModel: Model not in cdimage:", model)
		return
	end

	RequestModel(model)

	local startTime = GetGameTimer()

	while not HasModelLoaded(model) do
		Wait(0)

		if GetGameTimer() - startTime > timeout then
			debugprint("LoadModel: Timed out loading model:", model, "after", timeout, "ms")
			return
		end
	end

	return model
end

---@param ptfx string
---@return string ptfx
function LoadPtfx(ptfx)
	RequestNamedPtfxAsset(ptfx)

	while not HasNamedPtfxAssetLoaded(ptfx) do
		Wait(0)
	end

	UseParticleFxAsset(ptfx)

	return ptfx
end

---Get the instructional key (\~INPUT_XXX\~) for a key mapping
---@param command string
---@return string
function GetInstructional(command)
	local hash = joaat("+" .. command)
	local hex = string.format("%x", hash):upper()

	if hash < 0 then
		hex = string.gsub(hex, string.rep("F", 8), "")
	end

	return "~INPUT_" .. hex .. "~"
end

---@class LoafWrapperNewBlipOptions
---@field label string
---@field coords vector2 | vector3 | vector4
---@field sprite? number
---@field color? number
---@field scale? number
---@field category? number
---@field shortRange? boolean # Defalts to true
---@field display? number # Defaults to 2 (map and minimap)

---@param options LoafWrapperNewBlipOptions
---@return number blip
function CreateBlip(options)
	local coords = options.coords
	local label = options.label
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z or 0.0)

	if options.sprite then
		SetBlipSprite(blip, options.sprite)
	end

	if options.color then
		SetBlipColour(blip, options.color)
	end

	if options.scale then
		SetBlipScale(blip, options.scale)
	end

	if options.category then
		SetBlipCategory(blip, options.category)
	end

	SetBlipDisplay(blip, options.display or 2)

	if options.shortRange == nil or options.shortRange then
		SetBlipAsShortRange(blip, true)
	end

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(label)
	EndTextCommandSetBlipName(blip)

	return blip
end

---Get an unused blip category. At the moment, this only checks for used labels
---@return number?
function GetEmptyBlipCategory()
	for i = 12, 133 do
		local textEntry = "BLIP_CAT_" .. i

		if GetFilenameForAudioConversation(textEntry) == "NULL" then
			return i
		end
	end
end

---@param desc string
---@param errType? "info" | "success" | "warning" | "error"
---@param title? string
function Notify(desc, errType, title)
	---@type string?
	local infoLevel = errType

	if Config.NotificationSystem == "ox_lib" then
		if errType == "info" then
			infoLevel = "inform"
		end

		exports.ox_lib:notify({
			title = title or desc,
			description = title and desc or nil,
			type = infoLevel,
		})
	elseif Config.NotificationSystem == "gta" then
		BeginTextCommandThefeedPost("STRING")
		AddTextComponentSubstringPlayerName(desc)
		EndTextCommandThefeedPostMessagetext(
			"CHAR_BLOCKED",
			"CHAR_BLOCKED",
			true,
			1,
			title or L("NOTIFICATION_TITLE"),
			""
		)
	elseif Config.Framework == "esx" then
		TriggerEvent("esx:showNotification", desc)
	elseif Config.Framework == "qb" or Config.Framework == "qbox" then
		TriggerEvent("QBCore:Notify", desc)
	end
end

---Check if a ped is wearing heels
---@param ped? number # The ped to check. If not provided, it will default to the player's ped.
---@return boolean wearingHeels
function IsPedWearingHeels(ped)
	ped = ped or PlayerPedId()

	if GetEntityModel(ped) ~= `mp_f_freemode_01` then
		debugprint("Not female ped, not wearing heels")
		return false
	end

	local shoes = GetPedDrawableVariation(ped, 6)
	local componentHash = GetHashNameForComponent(ped, 6, shoes, GetPedTextureVariation(ped, 6))

	if componentHash == 0 then
		return shoes == 0 or (shoes >= 6 and shoes <= 8) or shoes == 12 or shoes == 14
	end

	return DoesShopPedApparelHaveRestrictionTag(componentHash, `HIGH_HEELS`, 0)
end

---@param interior number
---@param offset vector3 | vector4
---@return vector3 coords
---@return number heading
function GetOffsetFromInterior(interior, offset)
    local heading = 0
    local interiorHeadingInRadians = GetInteriorHeading(interior)
    local pedCoords = GetOffsetFromInteriorInWorldCoords(interior, offset.x, offset.y, offset.z)

    if offset.w then
        heading = (math.deg(interiorHeadingInRadians) + offset.w) % 360
    end

    return pedCoords, heading
end
