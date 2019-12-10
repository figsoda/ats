local M = {}

local util = require("lib.util")

M.signalInput = util.proto.item {
    name = "signal-input",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    flags = { "hidden" },
    place_result = "signal-input",
    stack_size = 1,
}

M.signalOutput = util.proto.item {
    name = "signal-output",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    flags = { "hidden" },
    place_result = "signal-output",
    stack_size = 1,
}

M.trainScanner = util.proto.item {
    name = "train-scanner",
    icon = "__base__/graphics/icons/radar.png",
    icon_size = 32,
    subgroup = "automated-train-scheduling",
    place_result = "train-scanner",
    stack_size = 10,
    order = "d[automated-train-scheduling]-a[train-scanner]",
}

M.trainScheduler = util.proto.item {
    name = "train-scheduler",
    icon = "__base__/graphics/icons/beacon.png",
    icon_size = 32,
    subgroup = "automated-train-scheduling",
    place_result = "train-scheduler",
    stack_size = 10,
    order = "d[automated-train-scheduling]-b[train-scheduler]",
}

return M
