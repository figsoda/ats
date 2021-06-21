local M = {}

local util = require("lib.util")

M.id = util.proto.virtual({ name = "signal-I" })
M.pass = util.proto.virtual({ name = "signal-P" })
M.train = util.proto.virtual({ name = "signal-T" })
M.locomotive = util.proto.virtual({ name = "signal-locomotive" })
M.cargoWagon = util.proto.virtual({ name = "signal-cargo-wagon" })
M.fluidWagon = util.proto.virtual({ name = "signal-fluid-wagon" })
M.addStation = util.proto.virtual({ name = "signal-add-station" })
M.goToStation = util.proto.virtual({ name = "signal-go-to-station" })
M.trainStation = util.proto.virtual({ name = "signal-train-station" })
M.currentStation = util.proto.virtual({ name = "signal-current-station" })
M.temporary = util.proto.virtual({ name = "signal-temporary" })
M.compareType = util.proto.virtual({ name = "signal-compare-type" })
M.timePassed = util.proto.virtual({ name = "signal-time-passed" })
M.inactivity = util.proto.virtual({ name = "signal-inactivity" })
M.cargo = util.proto.virtual({ name = "signal-cargo" })
M.circuitCondition = util.proto.virtual({ name = "signal-circuit-condition" })
M.passenger = util.proto.virtual({ name = "signal-passenger" })

return M
