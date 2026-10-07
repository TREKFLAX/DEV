MenuItems = {
    -- Citizen category
    {
        id = 'citizen',
        label = _L('game.menu.citizen'),
        icon = 'user',
        items = {
            {
                id = 'givecontact',
                label = _L('game.menu.givecontact'),
                icon = 'address-book',
                event = 'qb-phone:client:GiveContactDetails',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'trunk_actions',
                label = _L('game.menu.trunk_actions'),
                icon = 'car',
                items = {
                    {
                        id = 'getintrunk',
                        label = _L('game.menu.getintrunk'),
                        icon = 'person-booth',
                        event = 'codem-radialmenu:client:GetInTrunk',
                        type = 'client',
                        shouldClose = true
                    },
                    {
                        id = 'putintrunk',
                        label = _L('game.menu.putintrunk'),
                        icon = 'user-ninja',
                        event = 'codem-trunk:client:InitKidnapTrunk',
                        type = 'client',
                        shouldClose = true
                    }
                }
            },
            {
                id = 'interactions',
                label = _L('game.menu.interactions'),
                icon = 'people-arrows',
                items = {
                    {
                        id = 'cuff',
                        label = _L('game.menu.cuff'),
                        icon = 'hands',
                        event = 'police:client:CuffPlayer',
                        type = 'client',
                        shouldClose = true
                    },
                    {
                        id = 'escort',
                        label = _L('game.menu.escort'),
                        icon = 'user-friends',
                        event = 'police:client:EscortPlayer',
                        type = 'client',
                        shouldClose = true
                    },
                    {
                        id = 'putinvehicle',
                        label = _L('game.menu.putinvehicle'),
                        icon = 'car-side',
                        event = 'police:client:PutPlayerInVehicle',
                        type = 'client',
                        shouldClose = true
                    }
                }
            }
        }
    },

    -- Blips category
    {
        id = 'blips',
        title = _L('game.menu.blips_title'),
        icon = 'map-marked-alt',
        items = {
            {
                id = 'allblipopen',
                label = _L('game.menu.allblipopen'),
                icon = 'eye',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'allblipclose',
                label = _L('game.menu.allblipclose'),
                icon = 'eye-slash',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'gasstation',
                label = _L('game.blip.gasstation'),
                icon = 'gas-pump',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'barbershop',
                label = _L('game.blip.barbershop'),
                icon = 'scissors',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'clothingshop',
                label = _L('game.blip.clothingshop'),
                icon = 'shirt',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'market',
                label = _L('game.blip.market'),
                icon = 'store',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'bank',
                label = _L('game.blip.bank'),
                icon = 'building-columns',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'garage',
                label = _L('game.blip.garage'),
                icon = 'warehouse',
                event = 'codem-supreme-radialmenu:openblip',
                type = 'client',
                shouldClose = true
            },
        }
    },

    -- General category
    {
        id = 'general',
        label = _L('game.menu.general'),
        icon = 'gear',
        items = {
            {
                id = 'clothing',
                label = _L('game.menu.clothing'),
                icon = 'shirt',
                items = {
                    {
                        id = 'hair',
                        label = _L('game.clothing.hair'),
                        icon = 'head-side-virus',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'hair' },
                        shouldClose = false
                    },
                    {
                        id = 'hat',
                        label = _L('game.clothing.hat'),
                        icon = 'hat-cowboy',
                        event = 'codem-radialmenu:client:ToggleProp',
                        type = 'client',
                        args = { component = 'hat' },
                        shouldClose = false
                    },
                    {
                        id = 'glasses',
                        label = _L('game.clothing.glasses'),
                        icon = 'glasses',
                        event = 'codem-radialmenu:client:ToggleProp',
                        type = 'client',
                        args = { component = 'glasses' },
                        shouldClose = false
                    },
                    {
                        id = 'mask',
                        label = _L('game.clothing.mask'),
                        icon = 'mask',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'mask' },
                        shouldClose = false
                    },
                    {
                        id = 'top',
                        label = _L('game.clothing.top'),
                        icon = 'tshirt',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'top' },
                        shouldClose = false
                    },
                    {
                        id = 'gloves',
                        label = _L('game.clothing.gloves'),
                        icon = 'mitten',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'gloves' },
                        shouldClose = false
                    },
                    {
                        id = 'vest',
                        label = _L('game.clothing.vest'),
                        icon = 'vest',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'vest' },
                        shouldClose = false
                    },
                    {
                        id = 'bag',
                        label = _L('game.clothing.bag'),
                        icon = 'bag-shopping',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'bag' },
                        shouldClose = false
                    },
                    {
                        id = 'shoes',
                        label = _L('game.clothing.shoes'),
                        icon = 'shoe-prints',
                        event = 'codem-radialmenu:client:ToggleClothing',
                        type = 'client',
                        args = { component = 'shoes' },
                        shouldClose = false
                    }
                }
            },
            {
                id = 'radialsettings',
                label = _L('game.menu.radialsettings'),
                icon = 'sliders',
                event = 'codem-radialmenu:client:OpenSettings',
                type = 'client',
                shouldClose = true
            }
        }
    },
}

-- Job-specific menu items (shown based on player's job)
-- Same structure as qb-radialmenu Config.JobInteractions
JobInteractions = {
    ['police'] = {
        id = 'police',
        label = _L('game.menu.police_actions'),
        icon = 'shield-halved',
        items = {
            {
                id = 'emergencybutton',
                label = _L('game.menu.emergencybutton'),
                icon = 'bell',
                event = 'police:client:SendPoliceEmergencyAlert',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'checkstatus',
                label = _L('game.menu.checkstatus'),
                icon = 'heart-pulse',
                event = 'police:client:CheckStatus',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'handcuff',
                label = _L('game.menu.handcuff'),
                icon = 'hands',
                event = 'police:client:CuffPlayer',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'escort',
                label = _L('game.menu.escort'),
                icon = 'user-friends',
                event = 'police:client:EscortPlayer',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'search',
                label = _L('game.menu.search_player'),
                icon = 'magnifying-glass',
                event = 'police:server:SearchPlayer',
                type = 'server',
                shouldClose = true
            },
            {
                id = 'jail',
                label = _L('game.menu.jail'),
                icon = 'building-lock',
                event = 'police:client:JailPlayer',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'takedriverlicense',
                label = _L('game.menu.revoke_license'),
                icon = 'id-card',
                event = 'police:client:SeizeDriverLicense',
                type = 'client',
                shouldClose = true
            }
        }
    },
    ['ambulance'] = {
        id = 'ambulance',
        label = _L('game.menu.ems_actions'),
        icon = 'truck-medical',
        items = {
            {
                id = 'checkstatus',
                label = _L('game.menu.checkstatus'),
                icon = 'stethoscope',
                event = 'hospital:client:CheckStatus',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'revive',
                label = _L('game.menu.revive'),
                icon = 'heart-pulse',
                event = 'hospital:client:RevivePlayer',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'heal',
                label = _L('game.menu.heal'),
                icon = 'bandage',
                event = 'hospital:client:TreatWounds',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'emergencybutton',
                label = _L('game.menu.emergencybutton'),
                icon = 'bell',
                event = 'police:client:SendPoliceEmergencyAlert',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'escort',
                label = _L('game.menu.escort'),
                icon = 'user-friends',
                event = 'police:client:EscortPlayer',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'takestretcher',
                label = _L('game.menu.takestretcher'),
                icon = 'bed',
                event = 'codem-supreme-radialmenu:client:TakeStretcher',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'removestretcher',
                label = _L('game.menu.removestretcher'),
                icon = 'trash',
                event = 'codem-supreme-radialmenu:client:RemoveStretcher',
                type = 'client',
                shouldClose = true
            }
        }
    },
    ['mechanic'] = {
        id = 'mechanic',
        label = _L('game.menu.mechanic_actions'),
        icon = 'wrench',
        items = {
            {
                id = 'towvehicle',
                label = _L('game.menu.towvehicle'),
                icon = 'truck-pickup',
                event = 'qb-tow:client:TowVehicle',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'repair',
                label = _L('game.menu.repair'),
                icon = 'screwdriver-wrench',
                event = 'mechanic:client:RepairVehicle',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'clean',
                label = _L('game.menu.clean'),
                icon = 'spray-can',
                event = 'mechanic:client:CleanVehicle',
                type = 'client',
                shouldClose = true
            }
        }
    },
    ['taxi'] = {
        id = 'taxi',
        label = _L('game.menu.taxi_actions'),
        icon = 'taxi',
        items = {
            {
                id = 'togglemeter',
                label = _L('game.menu.togglemeter'),
                icon = 'eye-slash',
                event = 'qb-taxi:client:toggleMeter',
                type = 'client',
                shouldClose = false
            },
            {
                id = 'togglemouse',
                label = _L('game.menu.togglemousemeter'),
                icon = 'hourglass-start',
                event = 'qb-taxi:client:enableMeter',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'npc_mission',
                label = _L('game.menu.npc_mission'),
                icon = 'taxi',
                event = 'qb-taxi:client:DoTaxiNpc',
                type = 'client',
                shouldClose = true
            }
        }
    },
    ['tow'] = {
        id = 'tow',
        label = _L('game.menu.tow_actions'),
        icon = 'truck-pickup',
        items = {
            {
                id = 'togglenpc',
                label = _L('game.menu.togglenpc'),
                icon = 'toggle-on',
                event = 'jobs:client:ToggleNpc',
                type = 'client',
                shouldClose = true
            },
            {
                id = 'towtruck',
                label = _L('game.menu.towvehicle'),
                icon = 'truck-pickup',
                event = 'qb-tow:client:TowVehicle',
                type = 'client',
                shouldClose = true
            }
        }
    },
    ['hotdog'] = {
        id = 'hotdog',
        label = _L('game.menu.hotdog_actions'),
        icon = 'hotdog',
        items = {
            {
                id = 'togglesell',
                label = _L('game.menu.togglesell'),
                icon = 'circle-dollar-to-slot',
                event = 'qb-hotdogjob:client:ToggleSell',
                type = 'client',
                shouldClose = true
            }
        }
    }
}

-- Vehicle door labels (used by main.lua for dynamic vehicle menu)
VehicleDoorLabels = {
    [0] = _L('game.vehicle.door_0'),
    [1] = _L('game.vehicle.door_1'),
    [2] = _L('game.vehicle.door_2'),
    [3] = _L('game.vehicle.door_3'),
    [4] = _L('game.vehicle.door_4'),
    [5] = _L('game.vehicle.door_5')
}
