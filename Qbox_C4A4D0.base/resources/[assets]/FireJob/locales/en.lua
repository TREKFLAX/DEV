Locales['en'] = {
    -- Duty / locker
    duty_press_context      = "Press ~INPUT_CONTEXT~ to %s",
    duty_clock_in           = "~g~Clock In~w~",
    duty_clock_out          = "~r~Clock Out~w~",
    duty_locker_gear_up     = "~w~Press ~INPUT_DETONATE~ to ~g~Gear Up",
    duty_locker_gear_down   = "~w~Press ~INPUT_DETONATE~ to ~y~Remove Gear",
    duty_on_patrol          = "~g~On Duty~w~ - Patrolling: ~b~%s",
    duty_off_no_aop         = "~r~Off Duty~w~ — No active AOP",
    zone_none               = "None",
    zone_station            = "Station",

    -- Turnout gear
    turnout_cancel_help     = "Hold ~INPUT_FRONTEND_CANCEL~ to cancel.",
    turnout_donning_label   = "Putting on Turnout Gear",
    turnout_removing_label  = "Removing Turnout Gear",
    turnout_not_firefighter = "~r~You are not a firefighter.",
    turnout_already_changing = "~y~You are already changing gear.",
    turnout_gear_already_on = "~y~Your gear is already on.",
    turnout_not_wearing_gear = "~y~You are not wearing turnout gear.",
    turnout_no_outfits      = "~r~No outfits saved in the SCBA system! Use /addoutfit first.",
    turnout_too_far_from_station = "~r~You must be at a fire station to use turnout gear.",
    turnout_too_far_from_locker  = "~r~You must be at the locker or a duty point to use turnout gear.",
    turnout_putting_on      = "~g~Putting on turnout gear...",
    turnout_stopped_putting_on = "~r~You stopped putting on your gear.",
    turnout_gear_on_scba    = "~g~Turnout gear on. Grab your SCBA from the truck!",
    turnout_removing        = "~y~Removing turnout gear...",
    turnout_stopped_removing = "~r~You stopped removing your gear.",
    turnout_gear_removed    = "~b~Turnout gear removed.",

    -- Player commands
    cmd_gearup_help         = "Open the turnout gear menu and put on your uniform.",
    cmd_geardown_help       = "Remove your turnout gear.",

    -- Gear menu
    gearmenu_dept_label         = "Fire Department",
    gearmenu_title              = "Turnout Gear",
    gearmenu_subtitle           = "Select your uniform before responding",
    gearmenu_cancel             = "Cancel",
    gearmenu_empty              = "No outfits available. Use /addoutfit in SCBA first.",
    gearmenu_npc_default        = "Firefighter Uniform",
    gearmenu_npc_subtitle       = "Standard issue uniform",
    gearmenu_outfit_subtitle    = "SCBA saved outfit",
    gearmenu_outfit_placeholder = "Outfit %d",

    -- Station alarms
    alarm_turnout_timer     = "TURNOUT TIMER  %02d:%02d",
    alarm_depart_now        = "DEPART NOW",
    alarm_station           = "STATION ALARM: %s EMERGENCY!",
    calltype_fire           = "FIRE",
    calltype_wildfire       = "WILDFIRE",
    calltype_medical        = "MEDICAL",
    calltype_hazmat         = "HAZMAT",
    calltype_rescue         = "RESCUE",
    calltype_smoke          = "SMOKE",
    calltype_scenario_manager = "SCENARIO MANAGER",

    -- Fire pole
    pole_slide_help         = "Press ~INPUT_CONTEXT~ to slide down the pole.",

    -- Light setup
    lightsetup_active_help  = "Setup Active (%s)~n~Shoot to place light. /setuplights to exit.",
    lightsetup_disabled     = "[LightSetup] Disabled.",
    lightsetup_usage        = "[LightSetup] Usage: /setuplights <stationId>",
    lightsetup_usage_example = "[LightSetup]                   e.g. /setuplights davis_fire",
    lightsetup_unknown_station = "[LightSetup] Unknown stationId '%s'. Defined in config?",
    lightsetup_enabled      = "[LightSetup] Setup Enabled for station '%s'",

    -- Speaker setup
    speaker_not_near        = "[Speaker] Not near a station!",
    speaker_place_help      = "[Speaker] Aim at a surface + E to place. X to exit. (station: '%s')",
    speaker_saved           = "[Speaker] Saved.",
    speaker_disabled        = "[Speaker] Disabled.",

    -- TV setup
    tvsetup_disabled        = "[TVSetup] Disabled.",
    tvsetup_usage           = "[TVSetup] Usage: /addtv <stationId>",
    tvsetup_unknown_station = "[TVSetup] Unknown stationId '%s'",
    tvsetup_enabled         = "[TVSetup] ENABLED for '%s' - arrows to rotate, E to place, X to exit",
    tvsetup_create_failed   = "[TVSetup] CreateFixedTV returned nil — check SmartTV errors.",
    tv_test_usage           = "[TV] Usage: /testtv <stationId>",

    -- Test alarm
    testalarm_not_firefighter = "[FireJob] You must be on duty as a firefighter to use this.",
    testalarm_usage         = "[FireJob] Usage: /testalarm <callType>",
    testalarm_defined_types = "[FireJob] Defined call types:",
    testalarm_unknown_type  = "[FireJob] Unknown call type '%s'",
    testalarm_no_station    = "[FireJob] No station found nearby.",
    testalarm_too_far       = "[FireJob] Too far from station to trigger alarm.",
    testalarm_triggering    = "[FireJob] Triggering %s alarm at '%s'",

    -- Server / admin commands
    cmd_setfire_help        = "Toggle standalone firefighter job for a player.",
    cmd_setfire_arg_player  = "Optional player server ID. Defaults to yourself.",
    server_player_not_found = "Player ID not found.",
    server_player_fired     = "Player %s has been fired from the Fire Department.",
    server_player_hired     = "Player %s has been hired to the Fire Department.",
}
