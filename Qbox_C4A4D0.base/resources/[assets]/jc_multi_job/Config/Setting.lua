Config = {}
Config.Debug = false

Config.Framework = 'auto' -- 'esx', 'qb', 'auto' or 'standalone'

Config.Notify = {
    Notification = 'ox_lib' -- 'ox_lib'  // 'esx_framework' // 'qb-core'
}

--[[
Configure your language using the following:
    'es' -> Spanish
    'en' -> English
    'fr' -> French
    'de' -> German
    'it' -> Italian
    'pt' -> Portuguese
]]
Config.Locale = 'en'

Config.MaxJobSlots = 3

-- The fallback job assigned when a player resigns from all owned jobs.
-- Default ESX & QB-Core job name is 'unemployed'. Change this if your server uses a custom job key (e.g. 'civilian', 'citizen').
Config.UnemployedJob = {
    name = 'unemployed',
    grade = 0
}

-- Cooldown (in seconds) before a player can switch active job again. Set 0 to disable.
Config.SwitchCooldown = 0

-- Enable or disable the job leaderboard ranking feature. Set false to disable.
Config.EnableLeaderboard = true

-- Number of entries shown on the job leaderboard.
Config.LeaderboardLimit = 15

-- Auto save interval for active duty seconds (in minutes). Set 0 to disable.
Config.DutyAutoSaveInterval = 3

Config.Keybind = {
    Enabled = true,
    Key = 'F6',
    Description = 'Open Multi Job Menu'
}

--[[
Command Name Configuration
Configure the command names used to trigger job management and admin actions.
]]
Config.Commands = {
    OpenMenu = 'multijob',        -- Client command to toggle UI
    AddJob = 'multiaddjob',       -- Server command: /multiaddjob [targetId] [jobname]
    RemoveJob = 'multiremovejob', -- Server command: /multiremovejob [targetId] [jobname]
    SetSlots = 'multijobslots',   -- Server command: /multijobslots [targetId] [amount]
}

--[[
Duty Button Configuration
Configure where the duty button appears in the job cards.
Set 'ShowInJobCard' to false to remove it from the job menu.
]]
Config.DutyButton = {
    ShowInJobCard = false, -- Set to false to hide duty button from job cards
}

--[[
Custom Job Configuration & UI Branding
Configure job labels, custom logo image URLs, and descriptions displayed in the UI.
'image' accepts any http(s) URL. If left empty (''), the UI falls back to the clean default icon.
]]
Config.Jobs = {
    { name = 'police',    label = 'Police Department',  image = '', description = 'Enforce the law and protect the city.' },
    { name = 'ambulance', label = 'Medical Department', image = '', description = 'Provide medical care and emergency assistance.' },
    { name = 'mechanic',  label = 'Mechanic Shop',      image = '', description = 'Repair and upgrade vehicles for citizens.' },
}

Config.JobsByName = {}
for i = 1, #Config.Jobs do
    Config.JobsByName[Config.Jobs[i].name] = Config.Jobs[i]
end
