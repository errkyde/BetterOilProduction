-- Better Oil Production — runtime script
-- Handles Fracking Station placement validation and oil-patch yield manipulation.

local PUMPJACK_NAMES = {
    "pumpjack",
    "better-pumpjack",
    "better-pumpjack-mk2",
    "better-pumpjack-eco",
}
-- Upgrade lineup: Pumpjack -> Better Pumpjack -> Better Pumpjack Mk2 (Eco is a side-grade).
local PUMPJACK_SET = {}
for _, n in ipairs(PUMPJACK_NAMES) do PUMPJACK_SET[n] = true end

-- Fracking adds (initial_amount / FRACKING_DIVISOR) oil units per second.
-- Cap: 150% of the patch's original initial_amount.
local FRACKING_DIVISOR = 1000
local FRACKING_CAP     = 1.50

-- EOR restores a % of a patch's initial_amount per second (percentage-based = constant time
-- regardless of field richness).  Cap: 70% of initial_amount.
-- Steam (0.00006): ~3.2 h  |  Light oil (0.0003): ~39 min  |  Polymer slurry (0.0006): ~19 min
local EOR_RATE_STEAM   = 0.00006
local EOR_RATE_OIL     = 0.0003
local EOR_RATE_POLYMER = 0.0006
local EOR_CAP          = 0.70
-- Half-extent (tiles) of the box scanned once at placement to flood-fill the contiguous
-- field the injector sits on. Generous enough to cover vanilla oil fields; bounded for perf.
local EOR_SEARCH_RADIUS = 48
-- Bumped whenever the cached field/cap layout changes so older entries are rebuilt on load.
local EOR_SCHEMA = 2

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
        if dx < 0.6 and dy > 2.0 and dy < 4.0 then return pump end  -- N / S
        if dy < 0.6 and dx > 2.0 and dx < 4.0 then return pump end  -- E / W
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Helper: find the crude-oil patch a pumpjack is draining
-- ---------------------------------------------------------------------------
-- Prefer the pumpjack's actual mining_target so we boost exactly the patch it
-- pumps from, not just the nearest one (matters on multi-patch fields). The
-- target can be nil if the drill hasn't selected a resource yet (e.g. just
-- placed, paused, or momentarily without a target), so fall back to the nearest
-- crude-oil patch within range in that case.

local function find_oil_patch(pumpjack)
    local target = pumpjack.mining_target
    if target and target.valid and target.name == "crude-oil" then
        return target
    end

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
-- Helper: format an oil amount for display (k / M suffix)
-- ---------------------------------------------------------------------------

local function format_oil(amount)
    if amount >= 1000000 then
        return string.format("%.2fM", amount / 1000000)
    elseif amount >= 1000 then
        return math.floor(amount / 1000 + 0.5) .. "k"
    end
    -- Below 1k, show the raw value so small/near-empty patches don't all read "0k".
    return tostring(math.floor(amount + 0.5))
end

-- ---------------------------------------------------------------------------
-- Helper: find the contiguous crude-oil field the injector sits on
-- ---------------------------------------------------------------------------

-- The injector occupies the tile a pumpjack would, so it restores exactly ONE oil field:
-- the connected cluster of crude-oil entities flood-filled from its footprint. A separate
-- field that merely happens to be nearby is excluded because it is not contiguous.
--
-- Returns an array of { patch, cap } structs. The cap is fixed at placement.
--
-- Baseline (the "original richness" we restore toward), in priority order:
--   1. patch.initial_amount — the true map-generated amount, when the engine exposes it.
--   2. prototype.normal_resource_amount — the 100%-yield reference. crude-oil's initial_amount
--      reads as nil in practice, so this is the path normally taken: EOR restores a depleted
--      field up to 70% YIELD (0.7 * normal_resource_amount).
-- The current amount is never used as the baseline: cap = 0.7 * current would sit below the
-- current amount, making every patch read as already complete (the "always complete" bug).
--
-- Resource entities have no unit_number, so contiguity is tracked by integer tile key.
local function eor_find_field(injector)
    local surface = injector.surface
    local pos     = injector.position

    -- One bounded scan; index every crude-oil tile in range by its integer position.
    local by_key = {}
    local in_range = surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = {
            { pos.x - EOR_SEARCH_RADIUS, pos.y - EOR_SEARCH_RADIUS },
            { pos.x + EOR_SEARCH_RADIUS, pos.y + EOR_SEARCH_RADIUS },
        },
    })
    for _, e in pairs(in_range) do
        by_key[math.floor(e.position.x) .. ":" .. math.floor(e.position.y)] = e
    end

    -- Seeds: crude-oil tiles inside the injector's 3×3 footprint.
    local queue, seen, field = {}, {}, {}
    local seeds = surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = { { pos.x - 1.5, pos.y - 1.5 }, { pos.x + 1.5, pos.y + 1.5 } },
    })
    for _, e in pairs(seeds) do
        local k = math.floor(e.position.x) .. ":" .. math.floor(e.position.y)
        if not seen[k] then seen[k] = true; queue[#queue + 1] = e end
    end

    -- Flood-fill over 8-neighbour adjacency, restricted to tiles found in range.
    while #queue > 0 do
        local e = table.remove(queue)
        -- Baseline: true original if available, else the 100%-yield reference. Never the
        -- current amount (that would put the cap below current and complete instantly).
        local ref = e.initial_amount
        if not ref then
            local normal = e.prototype.normal_resource_amount
            ref = (normal and normal > 0) and normal or e.amount
        end
        field[#field + 1] = { patch = e, cap = ref * EOR_CAP }
        local ex, ey = math.floor(e.position.x), math.floor(e.position.y)
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) then
                    local k = (ex + dx) .. ":" .. (ey + dy)
                    local n = by_key[k]
                    if n and not seen[k] then seen[k] = true; queue[#queue + 1] = n end
                end
            end
        end
    end

    return field
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
    if not patch then
        return_entity(entity, "bop-fracking-station", event.player_index)
        if event.player_index then
            game.players[event.player_index].create_local_flying_text({
                text     = { "bop.no-oil-patch-near-pumpjack" },
                position = pos,
            })
        end
        return
    end

    -- initial_amount is nil for infinite (vanilla) crude-oil; fall back to current amount.
    local initial = patch.initial_amount or patch.amount

    storage.bop.fracking.by_station[entity.unit_number] = {
        station        = entity,
        pumpjack       = pump,
        patch          = patch,
        initial_amount = initial,
        at_cap         = false,
    }
    storage.bop.fracking.by_pumpjack[pump.unit_number] = entity.unit_number
end

-- ---------------------------------------------------------------------------
-- EOR Injector — on_built
-- ---------------------------------------------------------------------------

local function on_eor_built(event)
    local entity = event.entity or event.created_entity
    local pos    = entity.position

    -- Must be placed directly over a crude-oil deposit (within the entity's 3×3 footprint).
    local nearby = entity.surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = { { pos.x - 1.5, pos.y - 1.5 }, { pos.x + 1.5, pos.y + 1.5 } },
    })
    if #nearby == 0 then
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
        injector = entity,
        field    = eor_find_field(entity),
        complete = false,
        schema   = EOR_SCHEMA,
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

    elseif PUMPJACK_SET[entity.name] then
        local station_id = storage.bop.fracking.by_pumpjack[entity.unit_number]
        if station_id then
            local data = storage.bop.fracking.by_station[station_id]
            -- Clean up storage before destroying the station (return_entity calls entity.destroy()
            -- which is silent and won't re-enter on_removed).
            storage.bop.fracking.by_station[station_id] = nil
            storage.bop.fracking.by_pumpjack[entity.unit_number] = nil
            if data and data.station and data.station.valid then
                return_entity(data.station, "bop-fracking-station", event.player_index)
            end
        end
    end
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
            storage.bop.fracking.by_station[id] = nil
        elseif not (patch and patch.valid) then
            -- Patch disappeared (mod interaction or edge case): stop wasting steam and clean up.
            station.active = false
            station.custom_status = nil
            storage.bop.fracking.by_station[id] = nil
            if data.pumpjack and data.pumpjack.valid then
                storage.bop.fracking.by_pumpjack[data.pumpjack.unit_number] = nil
            end
        else
            -- Migrate records written by an older storage schema that lack newer fields.
            -- (initial_amount/at_cap were added during 0.2.0 development; a save made with an
            -- intermediate build can carry station entries without them, which would otherwise
            -- nil-crash the arithmetic below.)
            if data.initial_amount == nil then
                data.initial_amount = (patch.initial_amount or patch.amount)
            end
            if data.at_cap == nil then data.at_cap = false end
            -- Guard against initial_amount=0 (infinite resource with no patch.amount fallback).
            local cap    = data.initial_amount > 0 and (data.initial_amount * FRACKING_CAP) or math.huge
            local at_cap = patch.amount >= cap
            if at_cap then
                -- Pause the station on first transition to cap so it stops consuming steam.
                -- The inactive state is circuit-readable, allowing automation to detect saturation.
                if not data.at_cap then
                    data.at_cap    = true
                    station.active = false
                end
            else
                if data.at_cap then
                    data.at_cap    = false
                    station.active = true
                end
                -- Avoid status-based check (recipe cycle can sync with tick, causing a transient
                -- non-working state every check). Instead verify steam is present in the buffer.
                local steam = station.get_fluid_contents()["steam"]
                local pump  = data.pumpjack
                if steam and steam > 0
                   and pump and pump.valid
                   and pump.status == defines.entity_status.working then
                    -- LuaEntity has no `mining_speed` field; that lives on the prototype.
                    -- Effective (module/beacon-boosted) speed = base × (1 + speed_bonus).
                    local effective_speed = pump.prototype.mining_speed * (1 + pump.speed_bonus)
                    local rate = (data.initial_amount / FRACKING_DIVISOR) * effective_speed
                    patch.amount = math.min(patch.amount + rate, cap)
                end
            end
            -- Set a readable status on the fracking station entity.
            if at_cap then
                station.custom_status = {
                    diode = defines.entity_status_diode.green,
                    label = { "bop.fracking-saturated" },
                }
            else
                station.custom_status = {
                    diode = defines.entity_status_diode.yellow,
                    label = { "bop.fracking-boosting" },
                }
            end
        end
    end

    -- EOR
    for id, data in pairs(storage.bop.eor.by_injector) do
        local injector = data.injector
        if not (injector and injector.valid) then
            storage.bop.eor.by_injector[id] = nil
        else
            -- Rebuild entries from any older schema (old radius-scan with data.patches, or an
            -- earlier field layout whose caps were computed differently). Re-enable the machine
            -- in case the old logic had paused it.
            if data.schema ~= EOR_SCHEMA then
                data.field      = eor_find_field(injector)
                data.complete   = false
                data.schema     = EOR_SCHEMA
                injector.active = true
            end

            if data.complete then
                -- One-shot: the field reached 70%. The injector is meant to be removed and
                -- replaced by a pumpjack, so it stays off and simply shows the completed status.
                if #data.field > 0 then
                    injector.custom_status = {
                        diode = defines.entity_status_diode.green,
                        label = { "bop.eor-complete" },
                    }
                else
                    injector.custom_status = nil
                end
            else
                -- Recovery rate is 0 unless the machine is actively crafting (has fluid + power).
                local rate_multiplier = 0
                if injector.status == defines.entity_status.working then
                    local recipe = injector.get_recipe()
                    local base_rate
                    if recipe and recipe.name == "bop-eor-steam-process" then
                        base_rate = EOR_RATE_STEAM
                    elseif recipe and recipe.name == "bop-eor-polymer-process" then
                        base_rate = EOR_RATE_POLYMER
                    else
                        base_rate = EOR_RATE_OIL
                    end
                    rate_multiplier = base_rate * injector.crafting_speed
                end

                local total_current = 0
                local total_cap     = 0
                local all_complete  = true

                for i = #data.field, 1, -1 do
                    local entry = data.field[i]
                    if not entry.patch.valid then
                        table.remove(data.field, i)
                    else
                        local cap = entry.cap
                        if cap > 0 then
                            if entry.patch.amount < cap then
                                all_complete = false
                                if rate_multiplier > 0 then
                                    -- Per-tile fill scales with that tile's own richness
                                    -- (initial = cap / EOR_CAP), clamped exactly to the cap.
                                    local initial = cap / EOR_CAP
                                    entry.patch.amount = math.min(entry.patch.amount + initial * rate_multiplier, cap)
                                end
                            end
                            total_current = total_current + math.min(entry.patch.amount, cap)
                            total_cap     = total_cap + cap
                        end
                    end
                end

                if total_cap <= 0 then
                    -- Field exhausted/removed under the injector — nothing to restore.
                    injector.custom_status = nil
                elseif all_complete then
                    -- First and only transition to complete: stop and lock in 100%.
                    data.complete   = true
                    injector.active = false
                    injector.custom_status = {
                        diode = defines.entity_status_diode.green,
                        label = { "bop.eor-complete" },
                    }
                else
                    injector.custom_status = {
                        diode = defines.entity_status_diode.yellow,
                        label = {
                            "bop.eor-progress",
                            math.floor(total_current / total_cap * 100),
                            format_oil(total_current),
                            format_oil(total_cap),
                        },
                    }
                end
            end
        end
    end
end)
