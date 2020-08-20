local M = {}

M.pixels = function(x, y)
    return { x / 32, y / 32 }
end

M.rotate = function(dir, ang)
    return (dir + ang) % 8
end

M.increase = function(mx, k, x)
    mx[k] = (mx[k] or 0) + x
end

M.addPrerequisite = function(name, prereq)
    local tech = data.raw.technology[name]
    if data.raw.technology[prereq] ~= nil then
        if tech.prerequisites == nil then
            tech.prerequisites = { prereq }
        else
            table.insert(tech.prerequisites, prereq)
        end
    end
end

M.iconWithColor = function(color, icon, size, scale)
    return {
        {
            icon = "__base__/graphics/icons/signal/signal_" .. color .. ".png",
            icon_size = 64,
        },
        {
            icon = icon,
            icon_size = size or 64,
            scale = scale or 0.375,
        },
    }
end

M.filter = function(xs, f)
    local len = #xs
    local n = 1

    for i = 1, len do
        local x = xs[i]
        if f(x) then
            xs[n] = x
            n = n + 1
        end
    end

    for i = n, len do
        xs[i] = nil
    end
end

M.any = function(mx, f)
    for k, v in pairs(mx) do
        if f(k, v) then
            return true
        end
    end

    return false
end

M.fields = function(mx, xs)
    local my = {}

    for i = 1, #xs do
        local x = xs[i]
        my[x] = mx[x]
    end

    return my
end

M.merge = function(mx, my)
    local mz = {}

    for k, v in pairs(mx) do
        mz[k] = v
    end

    for k, v in pairs(my) do
        mz[k] = v
    end

    return mz
end

M.proto = setmetatable({}, {
    __index = function(_, key)
        return function(mx)
            return M.merge(mx, {
                type = key:gsub("([A-Z])", function(x)
                    return "-" .. x:lower()
                end)
            })
        end
    end
})

M.destroyEntity = function(entity)
    if entity ~= nil and entity.valid then
        entity.destroy()
    end
end

M.reviveOrCreate = function(surface, opts)
    local entity = surface.find_entities_filtered({
        name = opts.name,
        position = opts.position,
        direction = opts.direction,
        force = opts.force,
        limit = 1,
    })[1]
    if entity ~= nil then return entity end

    local ghost = surface.find_entities_filtered({
        ghost_name = opts.name,
        position = opts.position,
        direction = opts.direction,
        force = opts.force,
        limit = 1,
    })[1]
    if ghost ~= nil then
        _, entity = ghost.silent_revive()
        if entity ~= nil then return entity end
    end

    return surface.create_entity({
        name = opts.name,
        position = opts.position,
        direction = opts.direction,
        force = opts.force,
    })
end

M.attach = function(entity, name, offset, rotation)
    offset.x = offset.x or offset[1] or 0
    offset.y = offset.y or offset[2] or 0

    local att = M.reviveOrCreate(entity.surface, {
        name = name,
        position = { entity.position.x + offset.x, entity.position.y + offset.y },
        direction = M.rotate(entity.direction, rotation),
        force = entity.force
    })
    att.destructible = false
    att.rotatable = false

    return att
end

return M
