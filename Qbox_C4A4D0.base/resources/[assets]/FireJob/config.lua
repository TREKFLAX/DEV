Config = {
    -- Flip this on if you need the setup/debug commands
    -- (/setuplights, /addspeaker, /addtv, /testtv, /tvstate, /testalarm).
    -- Also turns on the noisy DebugPrint logs. Keep it off on a live server.
    Debug = false,

    -- Which language to use. Has to match one of the files in /locales
    -- (en, es, fr, de, pt, it, nl, pl, ru, zh).
    Locale = "en",

    Stations = {
        ["davis_fire"] = {
            coords = vector3(206.12, -1651.98, 29.8),
            radius = 100.0,  -- how far out the in-station HUD timer still shows
            aop = "city",    -- station gets toned for any call in this AOP
            -- Clock in/out and gear up here without needing the locker prop.
            -- The locker prop (Config.Locker.propHash) is NOT shipped with this
            -- resource -- it only exists if your fire station MLO includes it --
            -- so every station should have at least one dutyPoint, or players
            -- have no way to go on duty. Move these to wherever your station's
            -- changing room is.
            dutyPoints = {
                vector3(208.5, -1650.2, 29.8),
            },
            dutyPointRadius = 1.5, -- metres; defaults to Locker.distance
        },

        ["station7"] = {
            coords = vector3(1201.03, -1473.66, 34.86),
            radius = 100.0,
            aop = "city",
            dutyPoints = {
                vector3(1201.03, -1473.66, 34.86),
            },
        },
    },

    Turnout = {
        gearUpTime       = 30,     -- seconds to put gear on
        gearDownTime     = 15,     -- seconds to take it off
        gearUpAnimDict   = "clothingshirt",
        gearUpAnimName   = "try_shirt_positive_a",
        gearDownAnimDict = "clothingshirt",
        gearDownAnimName = "try_shirt_negative_a",
        animDict         = "clothingshirt", -- used when no direction-specific anim is set
        animName         = "try_shirt_positive_a",
        blocksMovement   = true,
    },

    -- The locker prop people use to clock in/out and to gear up/down.
    Locker = {
        propHash   = 2200060172,
        distance   = 1.5,
        gearControl = 47, -- 47 = G
        -- We only treat a locker prop as "ours" if it's within this many metres of
        -- one of the stations above. Otherwise the same model sitting in some random
        -- map building would also let players go on duty, which is not what we want.
        stationProximityRadius = 500.0,
        -- Draw a small marker at each configured duty point so firefighters can
        -- actually find where to clock in ("we don't see anywhere to go on
        -- duty"). Only players who pass the job check see it. Set false if your
        -- MLO has the locker prop and you'd rather keep the spots unmarked.
        showDutyPointMarkers = true,
        -- Optional global duty points (used at any station within stationProximityRadius).
        -- Prefer per-station dutyPoints in Stations when you can.
        -- dutyPoints = {},
        -- dutyPointRadius = 1.5,
    },

    peds = {
        firemanNpc = {
            -- "label" is optional - if you skip it we use the gearmenu_npc_default locale string
            model            = "s_m_y_fireman_01",
            scbaComponent    = 9,    -- ped backpack slot the tank lives on
            scbaDrawableOff  = 0,    -- drawable id that means "tank off"
            scbaTexture      = 0,
        },
    },

    TVs = {
        propModel = "prop_tv_flat_01",

        -- How long the alert video should run until the countdown hits ~00:00.
        -- Tune this to match your alertUrl video.
        alertDurationMs = 30000,
        -- After the countdown reaches 00:00, keep that frame up this long, then
        -- turn the TV off (or revert to idleUrl if set).
        zeroHoldMs = 90000,
        alertUrl = "https://www.youtube.com/watch?v=KpfSuZshI00",
        -- Empty = TV off / blank prop when idle. Do not leave a frozen last frame.
        idleUrl = ""
    },

    Alarm = {
        cooldownMs       = 15000,
        lightDurationMs  = 15000,
        turnoutTimerMs   = 45000,
        lightDrawRange   = 30.0,
        -- Hard cap on how many station lights any one client draws at once.
        -- Closest lights win. Keep this modest — spinning uses spotlights and
        -- those get expensive fast (aim for 4–8 placed lights per station).
        maxActiveLights  = 6,
        audioBank        = "audiodirectory/firejob_sounds",
        soundsetName     = "firetones_soundset",
        introSound       = "boop_boop_boop",
        introDurationMs  = 1500,
        mainSoundDurationMs = 13500,
    },

    CallTypes = {
        ["fire"] = {
            pattern   = "spinning",
            color     = { r = 255, g = 0, b = 0 },
            radius    = 12.0,
            intensity = 12.0,
            spinSpeed = 0.2,
            mainSound = "fire_tones",
        },
        ["wildfire"] = {
            pattern   = "double_strobe",
            color     = { r = 255, g = 0, b = 0 },
            radius    = 12.0,
            intensity = 12.0,
            mainSound = "fire_tones",
        },
        ["medical"] = {
            pattern   = "wig_wag",
            color1    = { r = 255, g = 0,   b = 0 },
            color2    = { r = 255, g = 255, b = 255 },
            radius    = 10.0,
            intensity = 10.0,
            mainSound = "ems_dispatch_tone",
        },
        ["hazmat"] = {
            pattern   = "pulse",
            color     = { r = 255, g = 140, b = 0 },
            radius    = 10.0,
            intensity = 10.0,
            mainSound = "ems_dispatch_tone",
        },
        ["rescue"] = {
            pattern   = "wig_wag",
            color1    = { r = 255, g = 100, b = 0 },
            color2    = { r = 255, g = 255, b = 255 },
            radius    = 10.0,
            intensity = 10.0,
            mainSound = "fire_tones",
        },
        ["smoke"] = {
            pattern   = "pulse",
            color     = { r = 200, g = 200, b = 200 },
            radius    = 8.0,
            intensity = 8.0,
            mainSound = "fire_tones",
        },
        ["scenario_manager"] = {
            pattern   = "pulse",
            color     = { r = 255, g = 220, b = 0 },
            radius    = 10.0,
            intensity = 10.0,
            mainSound = "fire_tones",
        },
    },

    CallTypeMap = {
        ["smoke"]             = "smoke",
        ["rescue"]              = "rescue",
        ["callout"]             = "scenario_manager",
        ["scenario_manager"]    = "scenario_manager",

        ["chemical"]   = "hazmat",
        ["electrical"] = "fire",
        ["bonfire"]    = "wildfire",
        ["wildfire"]   = "wildfire",
        ["brush"]      = "wildfire",
        ["vehicle"]    = "fire",
        ["indoors"]    = "fire",

        ["*"]          = "fire",
    },

    Notifications = {
        Enabled = true,
        Framework = {
            QBCore = false,
            QBX = false,
            ESX = false,
            vRP = false,
            okok = false, -- https://okok.tebex.io/package/4724993
            TMC = false,
        },
    },

    -- Per-command lockdowns
    Commands = {
        SetFire = {
            AcePermissions = {
                Enabled = false, -- turn this on to restrict /setfire to the command.setfire ACE
            },
        },
    },

    JobCheck = {
        EnablePermissions = true,
        RequireOnDuty = true, -- When true, players must be clocked on duty (toggled at a station locker)
        AcePermissions = {
            Enabled = false,
            Permission = "firejob.usescba"
        },
        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = true, 
                Jobs = {"fireman"}
            }
        },
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, 
                Groups = {"fireman"}, 
            },
            CheckPermission = {
                Enabled = false, 
                Permissions = {"fireman.usescba"} 
            },
        },
        QBCore = {
            Enabled = true,
            CheckJob = {
                Enabled = true,
                -- Must contain your server's EXACT fire job name from
                -- qb-core/shared/jobs.lua or nobody outside these jobs will see
                -- the locker/duty prompts. Common names are pre-listed; "ems"
                -- is kept for servers that run fire under their ambulance job.
                Jobs = {"fireman", "fire", "firefighter", "ems"},
            },
            CheckPermission = {
                Enabled = false, 
                Permissions = {"fireman.usescba"}, 
            },
        },
        QBX = {
            Enabled = true,
            CheckJob = {
                Enabled = true, 
                Jobs = {"fireman"}, 
            }
        },
        TMC = {
            Enabled = false,
            CheckJob = {
                Enabled = true,
                Jobs = { "sass" },
            },
            CheckPermission = {
                Enabled = false,
                Permissions = { "god", "admin" },
            },
        },
    },
}

Config.Locales = Locales

---@param key string
---@param ... any
---@return string
function L(key, ...)
    local locales = Config.Locales or {}
    local active = locales[Config.Locale] or locales.en or {}
    local fallback = locales.en or {}
    local str = active[key] or fallback[key] or key

    if select("#", ...) > 0 then
        return string.format(str, ...)
    end

    return str
end

--- Looks up the human-readable label for a given call type (used on station alarms).
---@param callType string
---@return string
function LCallType(callType)
    local key = "calltype_" .. tostring(callType or ""):lower()
    local label = L(key)
    if label == key then
        return string.upper(tostring(callType or "fire"))
    end
    return label
end