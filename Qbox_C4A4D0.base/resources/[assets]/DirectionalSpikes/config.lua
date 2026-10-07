config = {

    -- This is the distance the spikes will load in from, we recommend leaving this as 200.0 by default
    loadDistance = 200.0,

    -- This is the maximum distance you can be from a spike to use the removal command.
    maxDistanceToRemove = 5.0,

    -- If this is set to true, the types will completely explode on contact with a directional spike
    -- If this is set to false, the tyre will simply be flattened - but may burst at a later time in continued to be driven on
    popTyresOnContact = true,

    -- You can configure the resource to your desired language here
    -- If there is anything missing here, then please let the development team know and we can resolve this
    translations = {
        commandName = "spike",
        create = "create",
        remove = "remove",
        suggestion = "Create and remove directional spikes",
        suggestionHelp = "Create or remove",
        placingSpike = "Prese ENTER to finish Spike placement",
        grabObject = "Grab Object",
        rotateObject = "Rotate Object",
        changePermanence = "Change Permanence",
        permanent = "Permanent",
        temporary = "Temporary",
        cancelPlacement = "Cancel Placement",
        finishPlacement = "Place Object",
        permanenceStatus = "Directional spike is now ",
        enteringPlacementMode = "You are now in placement mode. Adjust the placement of the spike, and press ENTER to complete.",
        temporarySpikeCreated = "~g~Success: ~w~You have created a temporary directional spike.",
        permanentSpikeCreated = "~g~Success: ~w~You have created a permanent directional spike.",
        temporarySpikeRemoved = "~g~Success: ~w~You have removed your nearest temporary directional spike.",
        permanentSpikeRemoved = "~g~Success: ~w~You have removed your nearest permanent directional spike.",
        noSpikeNearby = "~r~Error: ~w~There is no spike nearby to remove.",
        noPermission = "~r~Error: ~w~You do not have permission to use this command.",
        incorrectUsage = "~r~Error: ~w~Incorrect usage. Use /spike create or /spike remove.",
        tooFarToRemove = "~r~Error: ~w~You are not in range of a directional spike.",
        commandSuggestion = "Create or remove a directional spike.",
    },


    -- This is the control configuration for the placement command
    -- You can find the correct control numbers here: https://docs.fivem.net/docs/game-references/controls/
    controls = {
        grabObject = 223,
        rotateObject = 250,
        changePermanence = 19,
        cancelPlacement = 177,
        finishPlacement = 191,
        showInstructions = 24
    },

    Notifications = {
        Enabled = true,
        Framework = {
            QBCore = false, 
            QBX = false,
            ESX = false,
            vRP = false, 
            okok = false, -- https://okok.tebex.io/package/4724993
        }
    },

    -- Here you can configure the permissions for the command
    -- By default permissions are disabled, allowing anyone to place or remove spikes
    -- Make sure you configure permissions BEFORE putting the resource into production to prevent abuse!
    permissions = {
        EnablePermissions = false,
        AcePermissions = {
            Enabled = true,
            Permissions = {"directionalspikes.use"}
            -- This enables ace permissions on the starchaser
        },
        -- We've added ESX integration. All you need to do is enable it below and configure which jobs can use the command
        ESX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"police"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"police"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"police"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"police"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"police"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"police"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }

}