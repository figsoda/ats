local M = {}

local util = require("lib.util")

M.showTrainStations = util.proto.customInput({
    name = "show-train-stations",
    key_sequence = "ALT + S",
})

return M
