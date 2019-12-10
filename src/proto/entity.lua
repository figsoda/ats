local M = {}

local util = require("lib.util")

M.signalInput = util.merge(data.raw["constant-combinator"]["constant-combinator"], {
    name = "signal-input",
    flags = {
        "placeable-off-grid",
        "player-creation",
        "not-repairable",
        "not-on-map",
        "not-deconstructable",
        "hidden",
        "hide-alt-info",
        "not-flammable",
        "not-upgradable",
    },
    max_health = 10000,
    healing_per_tick = 10000,
    collision_mask = { "layer-12" },
    allow_copy_paste = false,
    item_slot_count = 0,
    circuit_wire_max_distance = 10,
})
M.signalInput.minable = nil

M.signalOutput = util.merge(data.raw["constant-combinator"]["constant-combinator"], {
    name = "signal-output",
    flags = {
        "placeable-off-grid",
        "player-creation",
        "not-repairable",
        "not-on-map",
        "not-deconstructable",
        "hidden",
        "hide-alt-info",
        "not-flammable",
        "not-upgradable",
    },
    max_health = 10000,
    healing_per_tick = 10000,
    collision_mask = { "layer-12" },
    allow_copy_paste = false,
    item_slot_count = settings.startup["ats-signal-maximum"].value,
    circuit_wire_max_distance = 10,
})
M.signalOutput.minable = nil

M.trainScanner = util.proto.beacon {
    name = "train-scanner",
    icon = "__base__/graphics/icons/radar.png",
    icon_size = 32,
    flags = { "not-rotatable", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "train-scanner" },
    max_health = 400,
    corpse = "radar-remnants",
    dying_explosion = "medium-explosion",
    resistances = {
        util.proto.fire { percent = 70 },
        util.proto.impact { percent = 30 },
    },
    collision_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    selection_box = { { -2, -2 }, { 2, 2 } },
    tile_width = 4,
    tile_height = 4,
    selection_priority = 45,
    vehicle_impact_sound =  {
        filename = "__base__/sound/car-metal-impact.ogg",
        volume = 0.65,
    },
    energy_source = util.proto.electric {
        usage_priority = "secondary-input",
        buffer_capacity = "4MJ",
    },
    energy_usage = "2MW",
    distribution_effectivity = 0,
    supply_area_distance = 0,
    module_specification = {},
    base_picture = {
        filename = "__base__/graphics/entity/radar/radar.png",
        width = 98,
        height = 128,
        shift = util.pixels(1, -16),
        hr_version = {
            filename = "__base__/graphics/entity/radar/hr-radar.png",
            width = 196,
            height = 254,
            shift = util.pixels(1, -16),
            scale = 0.5,
        }
    },
    animation = {
        filename = "__base__/graphics/entity/radar/radar.png",
        width = 98,
        height = 128,
        frame_count = 64,
        line_length = 8,
        shift = util.pixels(1, -16),
        animation_speed = 0.25,
        hr_version = {
            filename = "__base__/graphics/entity/radar/hr-radar.png",
            width = 196,
            height = 254,
            frame_count = 64,
            line_length = 8,
            shift = util.pixels(1, -16),
            animation_speed = 0.25,
            scale = 0.5,
        },
    },
    animation_shadow = {
        filename = "__base__/graphics/entity/radar/radar-shadow.png",
        width = 172,
        height = 94,
        frame_count = 64,
        line_length = 8,
        shift = util.pixels(39, 3),
        animation_speed = 0.25,
        draw_as_shadow = true,
        hr_version = {
            filename = "__base__/graphics/entity/radar/hr-radar-shadow.png",
            width = 343,
            height = 186,
            frame_count = 64,
            line_length = 8,
            shift = util.pixels(39.25, 3),
            animation_speed = 0.25,
            draw_as_shadow = true,
            scale = 0.5,
        },
    },
    radius_visualisation_picture = {
        filename = "__core__/graphics/empty.png",
        width = 1,
        height = 1,
    },
}

M.trainScheduler = util.proto.beacon {
    name = "train-scheduler",
    icon = "__base__/graphics/icons/beacon.png",
    icon_size = 32,
    flags = { "not-rotatable", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "train-scheduler" },
    max_health = 300,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    collision_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    selection_box = { { -2, -2 }, { 2, 2 } },
    tile_width = 4,
    tile_height = 4,
    selection_priority = 45,
    resistances = {
        util.proto.fire { percent = 60 },
        util.proto.impact { percent = 30 },
    },
    vehicle_impact_sound =  {
        filename = "__base__/sound/car-metal-impact.ogg",
        volume = 0.65
    },
    energy_source = util.proto.electric {
        usage_priority = "secondary-input",
        buffer_capacity = "4MJ",
    },
    energy_usage = "1.2MW",
    distribution_effectivity = 0,
    supply_area_distance = 0,
    module_specification = {},
    base_picture = {
        filename = "__base__/graphics/entity/beacon/beacon-base.png",
        width = 116,
        height = 93,
        shift = util.pixels(11, 1.5),
    },
    animation = {
        filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
        width = 54,
        height = 50,
        line_length = 8,
        frame_count = 32,
        shift = util.pixels(-1, -55),
        animation_speed = 0.25,
    },
    animation_shadow = {
        filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
        width = 63,
        height = 49,
        line_length = 8,
        frame_count = 32,
        shift = util.pixels(100.5, 15.5),
        animation_speed = 0.25,
    },
    radius_visualisation_picture = {
        filename = "__core__/graphics/empty.png",
        width = 1,
        height = 1,
    },
}

return M
