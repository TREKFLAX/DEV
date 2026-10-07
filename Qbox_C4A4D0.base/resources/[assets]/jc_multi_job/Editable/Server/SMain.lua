local function IsCommandAllowed(source)
    if source == 0 then return true end

    return IsAdmin(source)
end

local function Multijob()
    return exports[GetCurrentResourceName()]
end

local addCmd = (Config.Commands and Config.Commands.AddJob) or 'multiaddjob'
lib.addCommand(addCmd, {
    help = 'Assign a new job to a player and set it active with an optional grade/rank',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target Player Server ID',
            optional = false,
        },
        {
            name = 'job',
            type = 'string',
            help = 'Job name (e.g., police, mechanic)',
            optional = false,
        },
        {
            name = 'grade',
            type = 'number',
            help = 'Job grade / rank level (optional, default 0)',
            optional = true,
        },
    },
}, function(source, args)
    if not IsCommandAllowed(source) then
        NotifyPlayer(source, Tr('no_permission'), 'error')
        return
    end

    local targetId = tonumber(args.target)
    local jobname = args.job
    local grade = tonumber(args.grade) or 0

    if not targetId or not jobname then return end

    local added = Multijob():AddJobToPlayer(targetId, jobname, grade)
    if added then
        Multijob():ForceSwitchJob(targetId, jobname)
    end
end)

local removeCmd = (Config.Commands and Config.Commands.RemoveJob) or 'multiremovejob'
lib.addCommand(removeCmd, {
    help = 'Remove a job from a player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target Player Server ID',
            optional = false,
        },
        {
            name = 'job',
            type = 'string',
            help = 'Job name (e.g., police, mechanic)',
            optional = false,
        },
    },
}, function(source, args)
    if not IsCommandAllowed(source) then
        NotifyPlayer(source, Tr('no_permission'), 'error')
        return
    end

    local targetId = tonumber(args.target)
    local jobname = args.job

    if not targetId or not jobname then return end

    Multijob():RemoveJobFromPlayer(targetId, jobname)
end)

local slotsCmd = (Config.Commands and Config.Commands.SetSlots) or 'multijobslots'
lib.addCommand(slotsCmd, {
    help = 'Set additional extra job slots for a player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target Player Server ID',
            optional = false,
        },
        {
            name = 'amount',
            type = 'number',
            help = 'Amount of extra job slots',
            optional = false,
        },
    },
}, function(source, args)
    if not IsCommandAllowed(source) then
        NotifyPlayer(source, Tr('no_permission'), 'error')
        return
    end

    local targetId = tonumber(args.target)
    local amount = tonumber(args.amount)

    if not targetId or not amount then return end

    Multijob():SetExtraSlots(targetId, amount)
end)
