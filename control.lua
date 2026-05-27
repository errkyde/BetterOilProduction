-- Better Oil Production — runtime script
-- Handles Fracking Station placement validation and oil-patch yield manipulation.

local PUMPJACK_NAMES = {
    "pumpjack",
    "better-pumpjack-mk2",
    "better-pumpjack-mk3",
    "better-pumpjack-eco",
}

-- Fracking adds (initial_amount / FRACKING_DIVISOR) oil units per second.
-- Cap: 110% of the patch's original initial_amount.
local FRACKING_DIVISOR = 10000
local FRACKING_CAP     = 1.10

-- EOR adds EOR_RATE oil units per second to every crude-oil patch within range.
-- Cap: 70% of the patch's original initial_amount.
local EOR_RATE    = 500
local EOR_CAP     = 0.70
local EOR_RADIUS  = 10   -- tiles

-- ---------------------------------------------------------------------------
-- Storage initialisation
-- ---------------------------------------------------------------------------

local function init_storage()
    storage.bop = storage.bop or {}
    storage.bop.fracking = storage.bop.fracking or { by_station = {}, by_pumpjack = {} }
    storage.bop.eor      = storage.bop.eor      or { by_injector = {} }
end

script.on_init(init_storage)
script.on_configuration_changed(init_storage)

-- ---------------------------------------------------------------------------
-- Helper: find an adjacent pumpjack (N/S/E/W only)
-- ---------------------------------------------------------------------------
-- Both machines are 3×3 and snap to integer tile positions.
-- When touching on a cardinal side the centre distance is exactly 3.
-- ---------------------------------------------------------------------------

local function find_adjacent_pumpjack(station)
    local pos     = station.position
    local surface = station.surface
    local nearby  = surface.find_entities_filtered({
        area  = { { pos.x - 5, pos.y - 5 }, { pos.x + 5, pos.y + 5 } },
        name  = PUMPJACK_NAMES,
    })
    for _, pump in pairs(nearby) do
        local dx = math.abs(pump.position.x - pos.x)
        local dy = math.abs(pump.position.y - pos.y)
        -- Cardinal adjacent: one axis ≈ 0, other ≈ 3 (touching 3×3 entities)
        if dx < 0.6 and dy > 2.0 and dy < 4.0 then return pump end  -- N / S
        if dy < 0.6 and dx > 2.0 and dx < 4.0 then return pump end  -- E / W
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Helper: find nearest crude-oil patch near a pumpjack
-- ---------------------------------------------------------------------------

local function find_oil_patch(pumpjack)
    local pos     = pumpjack.position
    local patches = pumpjack.surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = { { pos.x - 6, pos.y - 6 }, { pos.x + 6, pos.y + 6 } },
    })
    local best, best_dist = nil, math.huge
    for _, p in pairs(patches) do
        local d = (p.position.x - pos.x)^2 + (p.position.y - pos.y)^2
        if d < best_dist then best, best_dist = p, d end
    end
    return best
end

-- ---------------------------------------------------------------------------
-- Helper: return an entity to the player / spill it on the ground
-- ---------------------------------------------------------------------------

local function return_entity(entity, item_name, player_index)
    local pos     = entity.position
    local surface = entity.surface
    entity.destroy()
    if player_index and game.players[player_index] then
        local player = game.players[player_index]
        if player.can_insert({ name = item_name, count = 1 }) then
            player.insert({ name = item_name, count = 1 })
            return
        end
    end
    surface.spill_item_stack({ position = pos, stack = { name = item_name, count = 1 } })
end

-- ---------------------------------------------------------------------------
-- Fracking Station — on_built
-- ---------------------------------------------------------------------------

local function on_fracking_built(event)
    local entity = event.entity or event.created_entity
    local pos    = entity.position

    local pump = find_adjacent_pumpjack(entity)
    if not pump then
        return_entity(entity, "bop-fracking-station", event.player_index)
        if event.player_index then
            game.players[event.player_index].create_local_flying_text({
                text     = { "bop.no-adjacent-pumpjack" },
                position = pos,
            })
        end
        return
    end

    local existing = storage.bop.fracking.by_pumpjack[pump.unit_number]
    if existing and storage.bop.fracking.by_station[existing] then
        return_entity(entity, "bop-fracking-station", event.player_index)
        if event.player_index then
            game.players[event.player_index].create_local_flying_text({
                text     = { "bop.already-fracking" },
                position = pos,
            })
        end
        return
    end

    local patch   = find_oil_patch(pump)
    local initial = patch and patch.initial_amount or 0

    storage.bop.fracking.by_station[entity.unit_number] = {
        station        = entity,
        pumpjack       = pump,
        patch          = patch,
        initial_amount = initial,
    }
    storage.bop.fracking.by_pumpjack[pump.unit_number] = entity.unit_number
end

-- ---------------------------------------------------------------------------
-- EOR Injector — on_built
-- ---------------------------------------------------------------------------

local function on_eor_built(event)
    local entity = event.entity or event.created_entity
    local pos    = entity.position

    -- Must be placed on or directly over a crude-oil deposit.
    local patches = entity.surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = { { pos.x - 2, pos.y - 2 }, { pos.x + 2, pos.y + 2 } },
    })
    if #patches == 0 then
        return_entity(entity, "bop-eor-injector", event.player_index)
        if event.player_index then
            game.players[event.player_index].create_local_flying_text({
                text     = { "bop.no-oil-field" },
                position = pos,
            })
        end
        return
    end

    storage.bop.eor.by_injector[entity.unit_number] = {
        injector        = entity,
        initial_amounts = {},
    }
end

-- ---------------------------------------------------------------------------
-- Combined on_built handler
-- ---------------------------------------------------------------------------

local BUILD_EVENTS = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
}

-- Filters are only valid for single-event registrations; name check inside handler suffices.
script.on_event(BUILD_EVENTS, function(event)
    local entity = event.entity or event.created_entity
    if not (entity and entity.valid) then return end
    if entity.name == "bop-fracking-station" then
        on_fracking_built(event)
    elseif entity.name == "bop-eor-injector" then
        on_eor_built(event)
    end
end)

-- ---------------------------------------------------------------------------
-- Cleanup on removal / death
-- ---------------------------------------------------------------------------

local function on_removed(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if entity.name == "bop-fracking-station" then
        local data = storage.bop.fracking.by_station[entity.unit_number]
        if data then
            if data.pumpjack and data.pumpjack.valid then
                storage.bop.fracking.by_pumpjack[data.pumpjack.unit_number] = nil
            end
            storage.bop.fracking.by_station[entity.unit_number] = nil
        end

    elseif entity.name == "bop-eor-injector" then
        storage.bop.eor.by_injector[entity.unit_number] = nil

    elseif table.contains(PUMPJACK_NAMES, entity.name) then
        -- Pumpjack removed — free its fracking slot
        local station_id = storage.bop.fracking.by_pumpjack[entity.unit_number]
        if station_id then
            storage.bop.fracking.by_station[station_id] = nil
            storage.bop.fracking.by_pumpjack[entity.unit_number] = nil
        end
    end
end

-- table.contains helper (Factorio does not include it by default)
table.contains = table.contains or function(t, val)
    for _, v in pairs(t) do if v == val then return true end end
    return false
end

local REMOVE_EVENTS = {
    defines.events.on_entity_died,
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.script_raised_destroy,
}

script.on_event(REMOVE_EVENTS, on_removed)

-- ---------------------------------------------------------------------------
-- Tick processing — every 60 ticks (1 second at 60 UPS)
-- ---------------------------------------------------------------------------

script.on_nth_tick(60, function()
    -- Fracking
    for id, data in pairs(storage.bop.fracking.by_station) do
        local station = data.station
        local patch   = data.patch
        if not (station and station.valid) then
            -- Station gone without triggering on_removed — clean up
            storage.bop.fracking.by_station[id] = nil
        elseif patch and patch.valid
               and station.status == defines.entity_status.working then
            -- Only boost while the pumpjack itself is actively mining
            local pump = data.pumpjack
            if pump and pump.valid and pump.status == defines.entity_status.working then
                local cap  = data.initial_amount * FRACKING_CAP
                local rate = data.initial_amount / FRACKING_DIVISOR
                if patch.amount < cap then
                    patch.amount = math.min(patch.amount + rate, cap)
                end
            end
        end
    end

    -- EOR
    for id, data in pairs(storage.bop.eor.by_injector) do
        local injector = data.injector
        if not (injector and injector.valid) then
            storage.bop.eor.by_injector[id] = nil
        elseif injector.status == defines.entity_status.working then
            local pos     = injector.position
            local patches = injector.surface.find_entities_filtered({
                type = "resource",
                name = "crude-oil",
                area = {
                    { pos.x - EOR_RADIUS, pos.y - EOR_RADIUS },
                    { pos.x + EOR_RADIUS, pos.y + EOR_RADIUS },
                },
            })
            for _, patch in pairs(patches) do
                local initial = data.initial_amounts[patch.unit_number]
                if not initial then
                    initial = patch.initial_amount
                    data.initial_amounts[patch.unit_number] = initial
                end
                local cap  = initial * EOR_CAP
                -- Scale rate by effective crafting speed so speed modules and beacons matter.
                local rate = EOR_RATE * injector.crafting_speed
                if patch.amount < cap then
                    patch.amount = math.min(patch.amount + rate, cap)
                end
            end
        end
    end
end)
