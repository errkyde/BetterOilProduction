-- Krastorio 2: vanilla science packs are kept as-is; no recipe or technology changes needed.

local flags = require("feature-flags")

-- Wire vanilla pumpjack into the upgrade chain: Pumpjack → Better Pumpjack → Mk2
data.raw["mining-drill"]["pumpjack"].next_upgrade = "better-pumpjack"

if mods["space-age"] then
    require("prototypes.space-age")

    local atmo = {{ property = "pressure", min = 1 }}

    -- Per-tier heating energy: larger machines need more heat on cold planets like Aquilo.
    local heating = {
        ["better-pumpjack-eco"] = "50kW",   -- low-power, same as vanilla
        ["better-pumpjack"] = "75kW",   -- mid tier
        ["better-pumpjack-mk2"] = "100kW",  -- top tier
    }
    for name, heat in pairs(heating) do
        local drill = data.raw["mining-drill"][name]
        if drill then
            drill.surface_conditions = atmo
            drill.heating_energy = heat
        end
    end

    -- Mk2: top-tier industrial pumpjack — requires rocket launch + Vulcanus (heavy industry planet).
    -- Mirrors SA's treatment of other high-tier industrial technologies (artillery, speed-module-3, etc.).
    data.raw.technology["better-pumpjack-mk2"].prerequisites = { "better-pumpjack", "space-science-pack" }
    data.raw.technology["better-pumpjack-mk2"].unit = {
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
    data.raw.technology["better-pumpjack-eco"].prerequisites = { "advanced-oil-processing", "electric-engine", "space-science-pack", "agricultural-science-pack" }
    data.raw.technology["better-pumpjack-eco"].unit = {
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
            probability = 0.4,
        })
    end

    -- Refined Polymer Slurry: Space Age variant using solid fuel instead of raw coal.
    -- Solid fuel is a processed carbon carrier (made from light oil / petroleum gas),
    -- yielding 50% more slurry per batch. All ingredients are Nauvis first-planet resources.
    -- Polymer Slurry only exists for the EOR feature, so gate it with that flag.
    if flags.fracking_eor then
        data:extend({
            {
                type            = "recipe",
                name            = "bop-refined-polymer-slurry",
                category        = "chemistry",
                enabled         = false,
                energy_required = 8,
                icons = {
                    {
                        icon      = "__base__/graphics/icons/fluid/heavy-oil.png",
                        icon_size = 64,
                        tint      = { r = 0.55, g = 0.45, b = 0.10, a = 1.0 },
                    }
                },
                ingredients = {
                    { type = "fluid", name = "petroleum-gas", amount = 100 },
                    { type = "fluid", name = "sulfuric-acid", amount = 40  },
                    { type = "item",  name = "solid-fuel",    amount = 15  },
                },
                results = {
                    { type = "fluid", name = "bop-polymer-slurry", amount = 150 },
                },
            }
        })
        table.insert(data.raw.technology["bop-eor"].effects, {
            type = "unlock-recipe", recipe = "bop-refined-polymer-slurry"
        })
    end
end

if mods["Krastorio2"] then
    -- K2 doubles the vanilla pumpjack (mining_speed=2, 100kW).
    -- Scale stats and swap recipes to use K2 materials.

    -- Recipe overrides
    data.raw.recipe["better-pumpjack"].ingredients = {
        { type = "item", name = "pumpjack",                 amount = 1  },
        { type = "item", name = "kr-steel-beam",            amount = 10 },
        { type = "item", name = "kr-rare-metals",           amount = 8  },
        { type = "item", name = "kr-electronic-components", amount = 8  },
    }
    -- Mk2: mirror the base recipe shape (steel+engines+control+concrete) with K2 equivalents
    data.raw.recipe["better-pumpjack-mk2"].ingredients = {
        { type = "item", name = "better-pumpjack",    amount = 1  },
        { type = "item", name = "kr-steel-beam",          amount = 25 },
        { type = "item", name = "electric-engine-unit",   amount = 12 },
        { type = "item", name = "kr-energy-control-unit", amount = 5  },
        { type = "item", name = "concrete",               amount = 20 },
    }
    data.raw.recipe["better-pumpjack-eco"].ingredients = {
        { type = "item", name = "pumpjack",                 amount = 1  },
        { type = "item", name = "kr-steel-beam",            amount = 5  },
        { type = "item", name = "kr-electronic-components", amount = 5  },
        { type = "item", name = "efficiency-module",        amount = 3  },
    }

    -- Fracking Station + EOR Injector recipe overrides — only when that feature is enabled
    -- (otherwise these prototypes do not exist and indexing them would error).
    if flags.fracking_eor then
        -- Fracking Station: swap structural/electronic materials to K2 equivalents
        data.raw.recipe["bop-fracking-station"].ingredients = {
            { type = "item", name = "pumpjack",                 amount = 1  },
            { type = "item", name = "kr-steel-beam",            amount = 12 },
            { type = "item", name = "kr-electronic-components", amount = 10 },
            { type = "item", name = "pipe",                     amount = 5  },
            { type = "item", name = "iron-gear-wheel",          amount = 10 },
        }

        -- EOR Injector: swap structural/electronic materials to K2 equivalents;
        -- refined-concrete is vanilla and carries over unchanged.
        data.raw.recipe["bop-eor-injector"].ingredients = {
            { type = "item", name = "assembling-machine-3",   amount = 1  },
            { type = "item", name = "kr-energy-control-unit", amount = 8  },
            { type = "item", name = "kr-rare-metals",         amount = 20 },
            { type = "item", name = "kr-imersium-gear-wheel", amount = 10 },
            { type = "item", name = "refined-concrete",       amount = 20 },
            { type = "item", name = "electric-engine-unit",   amount = 8  },
        }
        -- Polymer Slurry uses vanilla coal — no K2 override needed (coal is unchanged in K2).
    end

    -- Energy/emission overrides for K2 finite-oil mode, which doubles the vanilla pumpjack
    -- (50→100 kW). The higher-throughput tiers draw proportionally more power here.
    -- Mining speeds are NOT set here: data-final-fixes.lua derives every tier's speed from the
    -- final vanilla pumpjack speed (Better = 2×, Mk2 = 4×, Eco = 0.5×), so the relationship
    -- holds automatically whether or not finite-oil is on.
    if settings.startup["kr-finite-oil"] and settings.startup["kr-finite-oil"].value then
        local better = data.raw["mining-drill"]["better-pumpjack"]
        if better then
            better.energy_usage = "420kW"
            better.energy_source.emissions_per_minute = { pollution = 36 }
        end
        local mk2 = data.raw["mining-drill"]["better-pumpjack-mk2"]
        if mk2 then
            mk2.energy_usage = "500kW"
            mk2.energy_source.emissions_per_minute = { pollution = 70 }
        end
        local eco = data.raw["mining-drill"]["better-pumpjack-eco"]
        if eco then
            eco.energy_usage = "110kW"
        end
    end
end

if mods["space-exploration"] then
    data.raw.technology["better-pumpjack-mk2"].prerequisites = { "better-pumpjack", "se-rocket-science-pack" }
    data.raw.technology["better-pumpjack-mk2"].unit = {
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

    data.raw.technology["better-pumpjack-eco"].prerequisites = { "advanced-oil-processing", "electric-engine", "se-rocket-science-pack" }
    data.raw.technology["better-pumpjack-eco"].unit = {
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
