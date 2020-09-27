local M = {}

local sigid = require("lib.sigid")
local util = require("lib.util")

local addSignal = function(sigs, signal, count)
    sigs.index = sigs.index + 1
    sigs.params[sigs.index] = {
        signal = signal,
        count = count,
        index = sigs.index,
    }
end

M.trainScanner = function(uid, scanner)
    local input = scanner.input
    if not scanner.entity.valid then
        util.destroyEntity(scanner.input)
        util.destroyEntity(scanner.output)
        global.trainScanners[uid] = nil
        return
    end
    local output = scanner.output.get_or_create_control_behavior()

    if scanner.entity.energy < 20000 then
        output.parameters = nil
        return
    end

    local train
    local sigs = {index = 0, params = {}}

    local tid = input.get_merged_signal(sigid.train)
    if tid == -1 then
        local len = #global.trainIds
        if len == 0 then
            output.parameters = nil
            return
        end

        scanner.index = scanner.index + 1
        if scanner.index > len then scanner.index = 1 end

        tid = global.trainIds[scanner.index]
        train = global.trains[tid]
        if train == nil then return end
        if not train.valid then
            table.remove(global.trainIds, scanner.index)
            global.trains[tid] = nil
            return M.trainScanner(uid, scanner)
        end

        addSignal(sigs, sigid.train, tid)
    elseif tid > 0 then
        train = global.trains[tid]
        if train == nil then return end
        if not train.valid then
            util.filter(global.trainIds, function(x) return x ~= tid end)
            global.trains[tid] = nil
        end
    else
        output.parameters = nil
        return
    end

    local locomotive = input.get_merged_signal(sigid.locomotive)
    local fronts = train.locomotives.front_movers
    local backs = train.locomotives.back_movers
    if locomotive == -1 or locomotive == -3 then
        for i = 1, #fronts do
            for name, count in pairs(fronts[i].get_fuel_inventory()
                                         .get_contents()) do
                addSignal(sigs, util.proto.item {name = name}, count)
            end
        end

        for i = 1, #backs do
            for name, count in pairs(backs[i].get_fuel_inventory()
                                         .get_contents()) do
                addSignal(sigs, util.proto.item {name = name}, count)
            end
        end
    end
    if locomotive == -2 or locomotive == -3 then
        addSignal(sigs, sigid.locomotive, #fronts + #backs)
    end

    local cargoWagon = input.get_merged_signal(sigid.cargoWagon)
    if cargoWagon == -1 or cargoWagon == -3 then
        for name, count in pairs(train.get_contents()) do
            addSignal(sigs, util.proto.item {name = name}, count)
        end
    end
    if cargoWagon == -2 or cargoWagon == -3 then
        addSignal(sigs, sigid.cargoWagon, #train.cargo_wagons)
    end

    local fluidWagon = input.get_merged_signal(sigid.fluidWagon)
    if fluidWagon == -1 or fluidWagon == -3 then
        for name, count in pairs(train.get_fluid_contents()) do
            addSignal(sigs, util.proto.fluid {name = name}, count)
        end
    end
    if fluidWagon == -2 or fluidWagon == -3 then
        addSignal(sigs, sigid.fluidWagon, #train.fluid_wagons)
    end

    local schedule = train.schedule
    if schedule ~= nil then
        local len = #schedule.records
        if len ~= 0 then
            local temporary = input.get_merged_signal(sigid.temporary)

            local trainStation = input.get_merged_signal(sigid.trainStation)
            if trainStation == -2 then
                addSignal(sigs, sigid.trainStation, len)
            elseif trainStation > 0 then
                local record = schedule.records[trainStation]
                if record ~= nil then
                    local station = record.station
                    if station ~= nil then
                        local sid = global.trainStationIds[record.station]
                        if sid ~= nil then
                            addSignal(sigs, sigid.trainStation, sid)
                            if (temporary == -1 or temporary == -3)
                                and record.temporary then
                                addSignal(sigs, sigid.temporary, 1)
                            end
                        end
                    end
                end
            end

            local currentStation = input.get_merged_signal(sigid.currentStation)
            if currentStation == -1 then
                local record = schedule.records[schedule.current]
                if record ~= nil then
                    local sid = global.trainStationIds[record.station]
                    if sid ~= nil then
                        addSignal(sigs, sigid.currentStation, sid)
                        if (temporary == -1 or temporary == -3)
                            and record.temporary then
                            addSignal(sigs, sigid.temporary, 2)
                        end
                    end
                end
            elseif currentStation == -2 then
                local record = schedule.records[schedule.current]
                if record ~= nil then
                    addSignal(sigs, sigid.currentStation, schedule.current)
                    if (temporary == -2 or temporary == -3) and record.temporary then
                        addSignal(sigs, sigid.temporary, 2)
                    end
                end
            end
        end
    end

    output.parameters = {parameters = sigs.params}
end

M.trainScheduler = function(uid, scheduler)
    local input = scheduler.input
    if not scheduler.entity.valid then
        util.destroyEntity(input)
        global.trainSchedulers[uid] = nil
        return
    end

    if scheduler.entity.energy < 12000 then return end

    local last = scheduler.id
    scheduler.id = input.get_merged_signal(sigid.id)
    if last ~= 0 and last ~= scheduler.id then return end

    local tid = input.get_merged_signal(sigid.train)
    if tid <= 0 then return end

    local train = global.trains[tid]
    if train == nil then return end
    if not train.valid then
        util.filter(global.trainIds, function(x) return x ~= tid end)
        global.trains[tid] = nil
    end

    local len = train.schedule == nil and 0 or #train.schedule.records

    local addStation = input.get_merged_signal(sigid.addStation)
    if addStation == -1 or addStation > 0 and addStation <= len + 1 then
        local station = global.trainStations[input.get_merged_signal(
            sigid.trainStation)]
        if station ~= nil then
            local schedule = train.schedule or {current = 1, records = {}}
            local record = {station = station.name, wait_conditions = {}}

            if input.get_merged_signal(sigid.temporary) ~= 0 then
                record.temporary = true
            end

            local i = 0
            local cmp = input.get_merged_signal(sigid.compareType) < 0 and "and"
                            or "or"

            local timePassed = input.get_merged_signal(sigid.timePassed)
            if timePassed > 0 then
                i = i + 1
                record.wait_conditions[i] =
                    util.proto.time {compare_type = cmp, ticks = timePassed}
            end

            local inactivity = input.get_merged_signal(sigid.inactivity)
            if inactivity > 0 then
                i = i + 1
                record.wait_conditions[i] =
                    util.proto.inactivity {
                        compare_type = cmp,
                        ticks = inactivity,
                    }
            end

            local cargo = input.get_merged_signal(sigid.cargo)
            if cargo ~= 0 then
                i = i + 1
                record.wait_conditions[i] {
                    type = cargo < 0 and "empty" or "full",
                    compare_type = cmp,
                }
            end

            if input.get_merged_signal(sigid.circuitCondition) ~= 0 then
                i = i + 1
                record.wait_conditions[i] =
                    util.proto.circuit {
                        compare_type = cmp,
                        condition = {
                            comparator = ">",
                            first_signal = sigid.pass,
                            constant = 0,
                        },
                    }
            end

            local passenger = input.get_merged_signal(sigid.passenger)
            if passenger ~= 0 then
                i = i + 1
                record.wait_conditions[i] =
                    {
                        type = passenger < 0 and "passenger_not_present"
                            or "passenger_present",
                        compare_type = cmp,
                    }
            end

            len = len + 1
            if addStation == -1 then
                schedule.records[len] = record
            else
                table.insert(schedule.records, addStation, record)
                if addStation <= schedule.current then
                    schedule.current = schedule.current + 1
                end
            end

            if schedule.current > len then schedule.current = len end

            train.schedule = schedule
        end
    end

    local goToStation = input.get_merged_signal(sigid.goToStation)
    if goToStation > 0 and goToStation <= len then
        train.go_to_station(goToStation)
    end
end

return M
