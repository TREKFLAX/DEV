Config = Config or {}

--[[
Server-Side Configuration (Private settings such as Discord Webhooks)
This file is executed server-side ONLY and is never exposed to the client.
]]

Config.DiscordLogging = {
  Enabled = false,

  --[[
    WebhookUrl Configuration:
    - You can set a single URL string for all jobs:
      WebhookUrl = 'https://discord.com/api/webhooks/...'

    - OR set specific webhooks per job name using a table.
      Use the 'default' key as fallback for unlisted jobs:
    ]]
  WebhookUrl = {
    default  =
    '',            -- Default webhook URL for any job not specified below
    police   = '', -- Specific webhook URL for police department
    mechanic = '', -- Specific webhook URL for mechanic shop
    taxi     = '', -- Specific webhook URL for taxi driver
  },

  Events = {
    JobAdded = true,    -- When admin adds job to player
    JobRemoved = true,  -- When player resigns or admin removes job
    JobSwitched = true, -- When player switches jobs
    DutyOn = true,      -- When player goes on duty
    DutyOff = true,     -- When player goes off duty
  },
}
