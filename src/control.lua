local update = require("lib.update")
local util = require("lib.util")

script.on_init(function()
    global.trains = {}
    global.trainIds = {}
    global.trainScanners = {}
    global.trainSchedulers = {}
    global.trainStations = {}
    global.trainStationIds = {}
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
        if global.trainStationIds[entity.backer_name] == nil then
            local sid = #global.trainStations + 1
            global.trainStationIds[entity.backer_name] = sid
            global.trainStations[sid] = entity.backer_name
        end
    end
end)

script.on_event(defines.events.on_entity_renamed, function(event)
    local entity = event.entity
    if entity.name == "train-stop" then
        if global.trainStationIds[entity.backer_name] == nil then
            local sid = #global.trainStations + 1
            global.trainStationIds[entity.backer_name] = sid
            global.trainStations[sid] = entity.backer_name
        end
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
    end
end)

script.on_event("show-train-stations", function(event)
    local player = game.get_player(event.player_index)
    if player.gui.center["train-stations-frame"] == nil then
        local gui = player.gui.center.add(util.proto.frame {
            name = "train-stations-frame",
            caption = { "caption.train-stations" },
            direction = "vertical",
        }).add(util.proto.scrollPane {
            name = "train-stations-scroll-pane",
        }).add(util.proto.table {
            name = "train-stations-table",
            column_count = 2,
        })

        for sid, name in pairs(global.trainStations) do
            gui.add(util.proto.label {
                name = sid,
                caption = sid,
            })
            gui.add(util.proto.label {
                name = name,
                caption = name,
            })
        end
    else
        player.gui.center["train-stations-frame"].destroy()
    end
end)

script.on_nth_tick(settings.global["ats-update-interval"].value, update.all)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "ats-update-interval" then
        script.on_nth_tick(nil)
        script.on_nth_tick(settings.global["ats-update-interval"].value, update.all)
    end
end)

