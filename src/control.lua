local update = require("lib.update")
local util = require("lib.util")

local addTrainStop = function(stop)
    local name = stop.backer_name
    local sid = global.trainStationIds[name]
    if sid == nil then
        sid = #global.trainStations + 1
        global.trainStations[sid] = {
            name = name,
            stops = { [stop.unit_number] = stop },
        }
        global.trainStationIds[name] = sid
    else
        global.trainStations[sid].stops[stop.unit_number] = stop
    end
end

local removeTrainStop = function(name, uid)
    local sid = global.trainStationIds[name]
    if sid ~= nil then
        global.trainStations[sid].stops[uid] = nil
    end
end

local updateAll = function()
    for uid, scanner in pairs(global.trainScanners) do
        update.trainScanner(uid, scanner)
    end

    for uid, scheduler in pairs(global.trainSchedulers) do
        update.trainScheduler(uid, scheduler)
    end
end

script.on_init(function()
    global = {
        trains = {}, -- Table Uint LuaTrain
        trainIds = {}, -- Array Uint
        trainScanners = {}, -- Table Uint { index :: Uint, entity, input, output :: LuaEntity }
        trainSchedulers = {}, -- Table Uint { entity, input :: LuaEntity }
        trainStations = {}, -- Table Uint { name :: String, stops :: Table Uint LuaEntity }
        trainStationIds = {}, -- Table String Uint
    }

    for _, surface in pairs(game.surfaces) do
        local trains = surface.get_trains()
        for i = 1, #trains do
            local train = trains[i]
            table.insert(global.trainIds, train.id)
            global.trains[train.id] = train
        end

        local stops = surface.find_entities_filtered({ name = "train-stop" })
        for i = 1, #stops do
            addTrainStop(stops[i])
        end
    end
end)

script.on_event(defines.events.on_train_created, function(event)
    util.filter(global.trainIds, function(id)
        return id ~= event.old_train_id_1 and id ~= event.old_train_id_2
    end)
    if event.old_train_id_1 ~= nil then
        global.trains[event.old_train_id_1] = nil
    end
    if event.old_train_id_2 ~= nil then
        global.trains[event.old_train_id_2] = nil
    end

    table.insert(global.trainIds, event.train.id)
    global.trains[event.train.id] = event.train
end)

script.on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
}, function(event)
    local entity = event.created_entity or event.entity
    if entity.name == "train-scanner" then
        entity.operable = false

        local input = util.attach(entity, "signal-input", { -0.5, 1 }, 4)
        input.operable = false

        local output = util.attach(entity, "signal-output", { 0.5, 1 }, 4)
        output.operable = false

        global.trainScanners[entity.unit_number] = {
            index = 1,
            entity = entity,
            input = input,
            output = output,
        }
    elseif entity.name == "train-scheduler" then
        entity.operable = false

        local input = util.attach(entity, "signal-input", { 0, 1 }, 4)
        input.operable = false

        global.trainSchedulers[entity.unit_number] = {
            entity = entity,
            input = input,
        }
    elseif entity.name == "train-stop" then
        addTrainStop(entity)
    end
end)

script.on_event(defines.events.on_entity_renamed, function(event)
    local entity = event.entity
    if entity.name == "train-stop" then
        removeTrainStop(event.old_name, entity.unit_number)
        addTrainStop(entity)
    end
end)

script.on_event({
    defines.events.on_entity_died,
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.script_raised_destroy,
}, function(event)
    local entity = event.entity
    if entity.name == "train-scanner" then
        local scanner = global.trainScanners[entity.unit_number]
        util.destroyEntity(scanner.input)
        util.destroyEntity(scanner.output)
        global.trainScanners[entity.unit_number] = nil
    elseif entity.name == "train-scheduler" then
        local scheduler = global.trainSchedulers[entity.unit_number]
        util.destroyEntity(scheduler.input)
        global.trainSchedulers[entity.unit_number] = nil
    elseif entity.name == "train-stop" then
        removeTrainStop(entity.backer_name, entity.unit_number)
    end
end)

script.on_event("show-train-stations", function(event)
    local center = game.get_player(event.player_index).gui.center
    if center["train-stations-frame"] == nil then
        local gui = center.add(util.proto.frame {
            name = "train-stations-frame",
            caption = { "captions.train-stations" },
            direction = "vertical",
        }).add(util.proto.scrollPane {
            name = "train-stations-scroll-pane",
        }).add(util.proto.table {
            name = "train-stations-table",
            column_count = 2,
        })

        for sid, station in pairs(global.trainStations) do
            local name = util.any(station.stops, function(_, stop)
                return not stop.get_or_create_control_behavior().disabled
            end) and station.name or "*** " .. station.name

            gui.add(util.proto.label {
                name = string.format("station-id-%d", sid),
                caption = sid,
            })
            gui.add(util.proto.label {
                name = string.format("station-name-%d", sid),
                caption = name,
            })
        end
    else
        center["train-stations-frame"].destroy()
    end
end)

script.on_nth_tick(settings.global["ats-update-interval"].value, updateAll)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "ats-update-interval" then
        script.on_nth_tick(nil)
        script.on_nth_tick(settings.global["ats-update-interval"].value, updateAll)
    end
end)

