local M = {}

local util = require("lib.util")

M.automatedTrainScheduling = util.proto.technology {
    name = "automated-train-scheduling",
    icon = "__base__/graphics/technology/automated-rail-transportation.png",
    icon_size = 128,
    effects = {
        util.proto.unlockRecipe { recipe = "train-scanner" },
        util.proto.unlockRecipe { recipe = "train-scheduler" },
    },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 },
        },
        time = 30,
    },
    order = "c-g-d",
}

return M
