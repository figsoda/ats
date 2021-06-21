local M = {}

local util = require("lib.util")

M.locomotive = util.proto.virtualSignal({
    name = "signal-locomotive",
    icons = util.iconWithColor("blue", "__base__/graphics/icons/locomotive.png"),
    subgroup = "virtual-signal-rolling-stock",
    order = "f[rolling-stock]-a[locomotive]",
})

M.cargoWagon = util.proto.virtualSignal({
    name = "signal-cargo-wagon",
    icons = util.iconWithColor(
        "blue",
        "__base__/graphics/icons/cargo-wagon.png"
    ),
    subgroup = "virtual-signal-rolling-stock",
    order = "f[rolling-stock]-b[cargo-wagon]",
})

M.fluidWagon = util.proto.virtualSignal({
    name = "signal-fluid-wagon",
    icons = util.iconWithColor(
        "blue",
        "__base__/graphics/icons/fluid-wagon.png"
    ),
    subgroup = "virtual-signal-rolling-stock",
    order = "f[rolling-stock]-c[fluid-wagon]",
})

M.addStation = util.proto.virtualSignal({
    name = "signal-add-station",
    icons = {
        {
            icon = "__base__/graphics/icons/signal/signal_green.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/train-stop.png",
            icon_size = 64,
            scale = 0.32,
            shift = { -2, 1 },
        },
        {
            icon = "__core__/graphics/add-icon.png",
            icon_size = 32,
            scale = 0.375,
            shift = { 8, -8 },
        },
    },
    subgroup = "virtual-signal-train-schedule",
    order = "g[train-schedule]-a[add-station]",
})

M.goToStation = util.proto.virtualSignal({
    name = "signal-go-to-station",
    icons = {
        {
            icon = "__base__/graphics/icons/signal/signal_green.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/train-stop.png",
            icon_size = 64,
            scale = 0.32,
            shift = { -2, 1 },
        },
        {
            icon = "__core__/graphics/goto-icon.png",
            icon_size = 32,
            scale = 0.375,
            shift = { 8, -8 },
        },
    },
    subgroup = "virtual-signal-train-schedule",
    order = "g[train-schedule]-b[go-to-station]",
})

M.trainStation = util.proto.virtualSignal({
    name = "signal-train-station",
    icons = {
        {
            icon = "__base__/graphics/icons/signal/signal_yellow.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/train-stop.png",
            icon_size = 64,
            scale = 0.32,
            shift = { -2, 1 },
        },
        {
            icon = "__core__/graphics/train-stop-in-map-view.png",
            icon_size = 32,
            scale = 0.25,
            shift = { 8, -8 },
        },
    },
    subgroup = "virtual-signal-train-schedule",
    order = "g[train-schedule]-c[train-station]",
})

M.currentStation = util.proto.virtualSignal({
    name = "signal-current-station",
    icons = {
        {
            icon = "__base__/graphics/icons/signal/signal_yellow.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/train-stop.png",
            icon_size = 64,
            scale = 0.32,
            shift = { -2, 1 },
        },
        {
            icon = "__core__/graphics/icons/mip/play.png",
            icon_size = 32,
            scale = 0.375,
            shift = { 8, -8 },
        },
    },
    subgroup = "virtual-signal-train-schedule",
    order = "g[train-schedule]-d[current-station]",
})

M.temporary = util.proto.virtualSignal({
    name = "signal-temporary",
    icons = util.iconWithColor(
        "yellow",
        "__core__/graphics/time-editor-icon.png",
        32,
        0.75
    ),
    subgroup = "virtual-signal-train-schedule",
    order = "g[train-schedule]-e[temporary]",
})

M.compareType = util.proto.virtualSignal({
    name = "signal-compare-type",
    icons = util.iconWithColor("pink", "__core__/graphics/and-or-icon.png"),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-a[compare-type]",
})

M.timePassed = util.proto.virtualSignal({
    name = "signal-time-passed",
    icons = util.iconWithColor(
        "red",
        "__core__/graphics/clock-icon.png",
        32,
        0.75
    ),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-b[time-passed]",
})

M.inactivity = util.proto.virtualSignal({
    name = "signal-inactivity",
    icons = util.iconWithColor(
        "red",
        "__core__/graphics/multiplayer-waiting-icon.png",
        32,
        0.75
    ),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-c[inactivity]",
})

M.cargo = util.proto.virtualSignal({
    name = "signal-cargo",
    icons = util.iconWithColor("red", "__base__/graphics/icons/cargo-wagon.png"),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-d[cargo]",
})

M.circuitCondition = util.proto.virtualSignal({
    name = "signal-circuit-condition",
    icons = util.iconWithColor(
        "red",
        "__base__/graphics/technology/circuit-network.png",
        128,
        0.1875
    ),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-e[circuit-condition]",
})

M.passenger = util.proto.virtualSignal({
    name = "signal-passenger",
    icons = util.iconWithColor(
        "red",
        "__ats__/graphics/icons/passenger.png",
        64,
        0.5
    ),
    subgroup = "virtual-signal-wait-condition",
    order = "h[wait-condition]-f[passenger]",
})

return M
