-- Krastorio 2: vanilla science packs are kept as-is; no recipe or technology changes needed.

if mods["space-age"] then
    require("prototypes.space-age")

    local atmo = {{ property = "pressure", min = 1 }}

    -- Per-tier heating energy: larger machines need more heat on cold planets like Aquilo.
    local heating = {
        ["better-pumpjack-eco"] = "50kW",   -- low-power, same as vanilla
        ["better-pumpjack-mk2"] = "75kW",   -- mid tier
        ["better-pumpjack-mk3"] = "100kW",  -- top tier
    }
    for name, heat in pairs(heating) do
        local drill = data.raw["mining-drill"][name]
        if drill then
            drill.surface_conditions = atmo
            drill.heating_energy = heat
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

    -- Fracking Station and EOR Injector are surface-bound machines — restrict to planets with atmosphere.
    for _, name in ipairs({ "bop-fracking-station", "bop-eor-injector" }) do
        local entity = data.raw["assembling-machine"][name]
        if entity then
            entity.surface_conditions = {{ property = "pressure", min = 1 }}
        end
    end

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
    -- Scale stats and swap recipes to use K2 materials.

    -- Recipe overrides
    data.raw.recipe["better-pumpjack-mk2"].ingredients = {
        { type = "item", name = "pumpjack",                 amount = 1  },
        { type = "item", name = "kr-steel-beam",            amount = 10 },
        { type = "item", name = "kr-rare-metals",           amount = 8  },
        { type = "item", name = "kr-electronic-components", amount = 8  },
    }
    data.raw.recipe["better-pumpjack-mk3"].ingredients = {
        { type = "item", name = "better-pumpjack-mk2",      amount = 1  },
        { type = "item", name = "kr-rare-metals",           amount = 20 },
        { type = "item", name = "kr-electronic-components", amount = 15 },
        { type = "item", name = "kr-energy-control-unit",   amount = 3  },
        { type = "item", name = "kr-imersium-gear-wheel",   amount = 5  },
    }
    data.raw.recipe["better-pumpjack-eco"].ingredients = {
        { type = "item", name = "pumpjack",                 amount = 1  },
        { type = "item", name = "kr-steel-beam",            amount = 5  },
        { type = "item", name = "kr-electronic-components", amount = 5  },
        { type = "item", name = "efficiency-module",        amount = 3  },
    }

    -- Fracking Station: swap structural/electronic materials to K2 equivalents
    data.raw.recipe["bop-fracking-station"].ingredients = {
        { type = "item", name = "pumpjack",                 amount = 1  },
        { type = "item", name = "kr-steel-beam",            amount = 12 },
        { type = "item", name = "kr-electronic-components", amount = 10 },
        { type = "item", name = "pipe",                     amount = 5  },
        { type = "item", name = "iron-gear-wheel",          amount = 10 },
    }

    -- EOR Injector: swap mid/late materials to K2 equivalents
    data.raw.recipe["bop-eor-injector"].ingredients = {
        { type = "item", name = "assembling-machine-3",     amount = 1  },
        { type = "item", name = "kr-energy-control-unit",   amount = 8  },
        { type = "item", name = "kr-rare-metals",           amount = 20 },
        { type = "item", name = "kr-imersium-gear-wheel",   amount = 10 },
        { type = "item", name = "productivity-module",      amount = 3  },
        { type = "item", name = "electric-engine-unit",     amount = 8  },
    }

    -- Stat overrides — scale proportionally to K2 baseline (2× vanilla)
    local mk2 = data.raw["mining-drill"]["better-pumpjack-mk2"]
    if mk2 then
        mk2.mining_speed = 4.0
        mk2.energy_usage = "200kW"
        mk2.energy_source.emissions_per_minute = { pollution = 36 }
    end
    local mk3 = data.raw["mining-drill"]["better-pumpjack-mk3"]
    if mk3 then
        mk3.mining_speed = 8.0
        mk3.energy_usage = "380kW"
        mk3.energy_source.emissions_per_minute = { pollution = 70 }
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
