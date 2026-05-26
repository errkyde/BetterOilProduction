-- Krastorio 2: vanilla science packs are kept as-is; no recipe or technology changes needed.

if mods["space-age"] then
    require("prototypes.space-age")

    local atmo = {{ property = "pressure", min = 1 }}

    for _, name in ipairs({ "better-pumpjack-mk2", "better-pumpjack-mk3", "better-pumpjack-eco" }) do
        local drill = data.raw["mining-drill"][name]
        if drill then
            -- Restrict to atmosphere-bearing planets (mirrors how base SA treats the vanilla pumpjack).
            drill.surface_conditions = atmo
            -- Required for survival on cold planets such as Aquilo (matches vanilla pumpjack: 50kW).
            drill.heating_energy = "50kW"
        end
    end

    -- MK3: top-tier industrial pumpjack — requires rocket launch + Vulcanus (heavy industry planet).
    -- Mirrors SA's treatment of other high-tier industrial technologies (artillery, speed-module-3, etc.).
    data.raw.technology["advanced-pumpjacks-mk3"].prerequisites = { "advanced-pumpjacks", "space-science-pack" }
    data.raw.technology["advanced-pumpjacks-mk3"].unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "space-science-pack",       1 },
        },
        time = 45
    }

    -- Eco: sustainable low-depletion pumpjack — requires rocket launch + Gleba (nature/biology planet).
    -- Thematically: Gleba's ecosystem focus aligns with the eco-efficiency concept.
    data.raw.technology["eco-pumpjacks"].prerequisites = { "advanced-oil-processing", "electric-engine", "space-science-pack", "agricultural-science-pack" }
    data.raw.technology["eco-pumpjacks"].unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",    1 },
            { "logistic-science-pack",      1 },
            { "chemical-science-pack",      1 },
            { "production-science-pack",    1 },
            { "utility-science-pack",       1 },
            { "space-science-pack",         1 },
            { "agricultural-science-pack",  1 },
        },
        time = 45
    }

    -- Carbonic asteroids yield hydrocarbon chunks alongside the normal carbon yield.
    local crushing = data.raw.recipe["carbonic-asteroid-crushing"]
    if crushing and crushing.results then
        table.insert(crushing.results, {
            type = "item",
            name = "bop-hydrocarbon-chunk",
            amount = 1,
            probability = 0.3,
        })
    end
end

if mods["Krastorio2"] then
    -- K2 doubles the vanilla pumpjack (mining_speed=2, 100kW).
    -- Scale our pumpjacks up to stay meaningful relative to the new baseline.
    local mk2 = data.raw["mining-drill"]["better-pumpjack-mk2"]
    if mk2 then
        mk2.mining_speed = 4.0
        mk2.energy_usage = "200kW"
        mk2.energy_source.emissions_per_minute = { pollution = 22 }
    end
    local mk3 = data.raw["mining-drill"]["better-pumpjack-mk3"]
    if mk3 then
        mk3.mining_speed = 8.0
        mk3.energy_usage = "380kW"
        mk3.energy_source.emissions_per_minute = { pollution = 45 }
    end
end

if mods["space-exploration"] then
    data.raw.technology["advanced-pumpjacks-mk3"].prerequisites = { "advanced-pumpjacks", "se-rocket-science-pack" }
    data.raw.technology["advanced-pumpjacks-mk3"].unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "production-science-pack",  1 },
            { "se-rocket-science-pack",   1 },
        },
        time = 45
    }

    data.raw.technology["eco-pumpjacks"].prerequisites = { "advanced-oil-processing", "electric-engine", "se-rocket-science-pack" }
    data.raw.technology["eco-pumpjacks"].unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "production-science-pack",  1 },
            { "utility-science-pack",     1 },
            { "se-rocket-science-pack",   1 },
        },
        time = 45
    }
end
