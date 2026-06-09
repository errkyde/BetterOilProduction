-- Better Oil Production — runtime script
-- Handles Fracking Station placement validation and oil-patch yield manipulation.

local PUMPJACK_NAMES = {
    "pumpjack",
    "better-pumpjack",
    "better-pumpjack-mk2",
    "better-pumpjack-eco",
}
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
local EOR_CAP             = 0.70
local EOR_RADIUS          = 10       -- tiles
local EOR_RESCAN_INTERVAL = 36000    -- ticks (~10 min at 60 UPS)

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
-- Helper: build EOR patch cache (all crude-oil within EOR_RADIUS of injector)
-- ---------------------------------------------------------------------------

-- Returns an array of {patch, initial} structs. Resource entities do not have unit_number
-- (world-generated entities are not player-created), so keyed tables are not used.
--
-- existing_cache: previous cache table passed on rescans so that stored initial values for
-- already-tracked patches are preserved. Without this, infinite resources (initial_amount=nil)
-- would get a new fallback on every rescan, drifting the cap as the field depletes.
local function eor_build_patch_cache(injector, existing_cache)
    local pos   = injector.position
    local found = injector.surface.find_entities_filtered({
        type = "resource",
        name = "crude-oil",
        area = {
            { pos.x - EOR_RADIUS, pos.y - EOR_RADIUS },
            { pos.x + EOR_RADIUS, pos.y + EOR_RADIUS },
        },
    })
    -- Build a lookup of previously stored initials so rescans don't reset them.
    local preserved = {}
    if existing_cache then
        for _, e in ipairs(existing_cache) do
            if e.patch.valid then preserved[e.patch] = e.initial end
        end
    end
    local cache = {}
    for _, p in pairs(found) do
        -- initial_amount is set by the map generator for finite deposits and for infinite
        -- resources in most contexts. When it is nil (script-placed deposits or certain modded
        -- resources), fall back to the stored initial from a prior scan. If that is also absent
        -- (first placement on an unknown patch), estimate a baseline by assuming the current
        -- amount represents the field already being at the EOR cap fraction of some original.
        -- Solving cap = initial * EOR_CAP = p.amount / EOR_CAP gives
        -- initial = p.amount / EOR_CAP^2, so the restored cap is p.amount / EOR_CAP
        -- (≈1.43× current). This keeps cap strictly above current so EOR actually runs
        -- rather than immediately flagging itself complete.
        local initial = p.initial_amount or preserved[p]
            or (p.amount / (EOR_CAP * EOR_CAP))
        cache[#cache + 1] = { patch = p, initial = initial }
    end
    return cache
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
        injector     = entity,
        patches      = eor_build_patch_cache(entity),
        rescan_at    = game.tick + EOR_RESCAN_INTERVAL,
        all_complete = false,
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
            -- Rescan runs outside the working-status check so progress and cap detection
            -- remain accurate even when the injector is paused by our script.
            if not data.patches or not data.rescan_at or game.tick >= data.rescan_at then
                data.patches   = eor_build_patch_cache(injector, data.patches)
                data.rescan_at = game.tick + EOR_RESCAN_INTERVAL
            end

            -- Recovery rate is 0 when the machine is not actively working (no fluid, no power,
            -- or deactivated). Progress tracking still runs so the UI stays accurate.
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

            local total_progress = 0
            local total_current  = 0
            local total_cap      = 0
            local patch_count    = 0
            local all_complete   = true

            for i = #data.patches, 1, -1 do
                local entry = data.patches[i]
                if not entry.patch.valid then
                    table.remove(data.patches, i)
                else
                    local initial = entry.initial
                    if initial > 0 then
                        local cap = initial * EOR_CAP
                        if entry.patch.amount < cap then
                            all_complete = false
                            if rate_multiplier > 0 then
                                entry.patch.amount = math.min(entry.patch.amount + initial * rate_multiplier, cap)
                            end
                        end
                        local amt      = math.min(entry.patch.amount, cap)
                        total_progress = total_progress + amt / cap
                        total_current  = total_current + math.floor(amt)
                        total_cap      = total_cap + math.floor(cap)
                        patch_count    = patch_count + 1
                    end
                end
            end

            -- Sync active state: pause when all patches hit cap, resume if they drop below again.
            if all_complete and patch_count > 0 and not data.all_complete then
                data.all_complete = true
                injector.active   = false
            elseif not all_complete and data.all_complete then
                data.all_complete = false
                injector.active   = true
            end

            -- Update the custom status shown in the entity info panel.
            if patch_count == 0 then
                injector.custom_status = nil
            elseif all_complete then
                injector.custom_status = {
                    diode = defines.entity_status_diode.green,
                    label = { "bop.eor-complete" },
                }
            else
                injector.custom_status = {
                    diode = defines.entity_status_diode.yellow,
                    label = {
                        "bop.eor-progress",
                        math.floor(total_progress / patch_count * 100),
                        format_oil(total_current),
                        format_oil(total_cap),
                    },
                }
            end
        end
    end
end)
