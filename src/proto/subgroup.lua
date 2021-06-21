local M = {}

local util = require("lib.util")

M.automatedTrainScheduling = util.proto.itemSubgroup({
    name = "automated-train-scheduling",
    group = "logistics",
    order = "g[automated-train-scheduling]",
})

M.virtualSignalRollingStock = util.proto.itemSubgroup({
    name = "virtual-signal-rolling-stock",
    group = "signals",
    order = "f[virtual-signal-rolling-stock]",
})

M.virtualSignalTrainSchedule = util.proto.itemSubgroup({
    name = "virtual-signal-train-schedule",
    group = "signals",
    order = "g[virtual-signal-train-schedule]",
})

M.virtualSignalWaitCondition = util.proto.itemSubgroup({
    name = "virtual-signal-wait-condition",
    group = "signals",
    order = "h[virtual-signal-wait-condition]",
})

return M
