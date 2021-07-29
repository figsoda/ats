local M = {}

local util = require("lib.util")

M.trainScanner = util.proto.recipe({
  name = "train-scanner",
  energy_required = 5,
  enabled = false,
  ingredients = {
    { "steel-plate", 10 },
    { "iron-gear-wheel", 5 },
    { "electronic-circuit", 5 },
    { "stone-brick", 5 },
  },
  result = "train-scanner",
})

M.trainScheduler = util.proto.recipe({
  name = "train-scheduler",
  energy_required = 5,
  enabled = false,
  ingredients = {
    { "steel-plate", 5 },
    { "copper-cable", 10 },
    { "electronic-circuit", 10 },
    { "stone-brick", 10 },
  },
  result = "train-scheduler",
})

return M
