local util = require("lib.util")

data:extend(
    {
        util.proto.intSetting {
            name = "ats-signal-maximum",
            setting_type = "startup",
            minimum_value = 1,
            default_value = 768,
        },
        util.proto.intSetting {
            name = "ats-update-interval",
            setting_type = "runtime-global",
            minimum_value = 1,
            default_value = 1,
        },
    }
)
