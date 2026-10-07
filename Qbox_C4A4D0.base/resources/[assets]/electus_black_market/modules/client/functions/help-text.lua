local drawingHelpText = false

---@alias LoafWrapperMultiHelpText [string, number | LoafWrapperKeyBind, string] # { text, control, instructionalKey }

---@param text string
---@param control? number | LoafWrapperKeyBind
---@param instructionalKey? string
---@param key? string
local function FormatHelpText(text, control, instructionalKey, key)
	local prefix = ""

	if type(control) == "table" then
		instructionalKey = control.instructional
		key = control.defaultKey
	end

	if control then
		if type(control) == "number" then
			prefix = "[" .. GetControlKey(control) .. "] "
		else
			prefix = "[" .. GetControlKey(control.hash) .. "] "
		end
	elseif key then
		prefix = "[" .. key .. "] "
	end

	if Config.HelpTextStyle == "gta" and instructionalKey then
		prefix = instructionalKey .. " "
	end

	return prefix .. text
end

---@param text string
---@param control? number | LoafWrapperKeyBind # The control key, e.g. 51
---@param instructionalKey? string # The instructional key, e.g. "\~INPUT_CONTEXT\~"
---@param key? string # The key to display, e.g. "E"
---@overload fun(helpTexts: LoafWrapperMultiHelpText[])
function DrawHelpText(text, control, instructionalKey, key)
	if drawingHelpText then
		return
	end

	drawingHelpText = true

	local helpText = ""

	if type(text) == "table" then
		---@diagnostic disable-next-line: cast-type-mismatch
		---@cast text LoafWrapperMultiHelpText[]

		for i = 1, #text do
			local helpTextEntry = text[i]

			helpText = helpText .. FormatHelpText(helpTextEntry[1], helpTextEntry[2], helpTextEntry[3])

			if i < #text then
				helpText = helpText .. "\n"
			end
		end
	else
		helpText = FormatHelpText(text, control, instructionalKey, key)
	end

	if Config.HelpTextStyle == "ox_lib" then
		exports.ox_lib:showTextUI(helpText, {
			style = {
				whiteSpace = "pre-line",
			},
		})
	elseif Config.HelpTextStyle == "okokTextUI" then
		exports["okokTextUI"]:Open(helpText, "darkgray", "right", true)
	elseif Config.HelpTextStyle == "jg-textui" then
		exports["jg-textui"]:DrawText(helpText)
	elseif Config.HelpTextStyle == "cd_drawtextui" then
		TriggerEvent("cd_drawtextui:ShowUI", "show", helpText)
	else
		BeginTextCommandDisplayHelp("STRING")
		AddTextComponentSubstringPlayerName(helpText)
		EndTextCommandDisplayHelp(0, true, true, 0)
	end
end

function ClearHelpText()
	drawingHelpText = false

	if Config.HelpTextStyle == "ox_lib" then
		exports.ox_lib:hideTextUI()
	elseif Config.HelpTextStyle == "okokTextUI" then
		exports["okokTextUI"]:Close()
	elseif Config.HelpTextStyle == "jg-textui" then
		exports["jg-textui"]:HideText()
	elseif Config.HelpTextStyle == "cd_drawtextui" then
		TriggerEvent("cd_drawtextui:HideUI")
	else
		ClearHelp(true)
	end
end
