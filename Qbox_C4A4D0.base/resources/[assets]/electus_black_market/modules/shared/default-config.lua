---@type LoafWrapperConfig
local defaultConfig = {}

defaultConfig.Debug = false
defaultConfig.DebugPoly = false

defaultConfig.Framework = "auto"
defaultConfig.NotificationSystem = "auto"
defaultConfig.MenuSystem = "auto"
defaultConfig.HelpTextStyle = "auto"
defaultConfig.Inventory = "auto"
defaultConfig.CompanyMoneySystem = "auto"
defaultConfig.DispatchSystem = "auto"
defaultConfig.BlackMoneyItem = "auto"

defaultConfig.Target = true

defaultConfig.MarkerColor = { r = 125, g = 75, b = 195, a = 150 }

Config = Config or {}

for k, v in pairs(defaultConfig) do
    if Config[k] == nil then
        Config[k] = v
    end
end
