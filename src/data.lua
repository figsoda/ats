local util = require("lib.util")

local customInput = require("proto.custom-input")
local entity = require("proto.entity")
local item = require("proto.item")
local recipe = require("proto.recipe")
local signal = require("proto.signal")
local subgroup = require("proto.subgroup")
local technology = require("proto.technology")

data:extend(
    {
        subgroup.automatedTrainScheduling,
        subgroup.virtualSignalRollingStock,
        subgroup.virtualSignalTrainSchedule,
        subgroup.virtualSignalWaitCondition,

        customInput.showTrainStations,

        entity.signalInput,
        entity.signalOutput,
        entity.trainScanner,
        entity.trainScheduler,

        item.signalInput,
        item.signalOutput,
        item.trainScanner,
        item.trainScheduler,

        recipe.trainScanner,
        recipe.trainScheduler,

        signal.locomotive,
        signal.cargoWagon,
        signal.fluidWagon,
        signal.addStation,
        signal.goToStation,
        signal.trainStation,
        signal.currentStation,
        signal.temporary,
        signal.compareType,
        signal.timePassed,
        signal.inactivity,
        signal.cargo,
        signal.circuitCondition,
        signal.passenger,

        technology.automatedTrainScheduling,
    }
)

if mods["Squeak Through"] ~= nil then
    require("__Squeak Through__/config")

    local exclude = {
        entity.signalInput,
        entity.signalOutput,
        entity.trainScanner,
        entity.trainScheduler,
    }

    for i = 1, #exclude do
        local proto = exclude[i]
        table.insert(
            exclusions, {
                apply_when_object_exists = util.fields(proto, {"type", "name"}),
                excluded_prototype_names = {proto.name},
            }
        )
    end
end
