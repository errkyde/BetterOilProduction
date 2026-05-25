-- Krastorio 2: vanilla science packs are kept as-is; no recipe or technology changes needed.

if mods["space-age"] then
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
    data.raw.technology["advanced-pumpjacks-mk3"].prerequisites = { "advanced-pumpjacks", "space-science-pack", "metallurgic-science-pack" }
    data.raw.technology["advanced-pumpjacks-mk3"].unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack",   1 },
            { "logistic-science-pack",     1 },
            { "chemical-science-pack",     1 },
            { "production-science-pack",   2 },
            { "utility-science-pack",      1 },
            { "space-science-pack",        1 },
            { "metallurgic-science-pack",  1 },
        },
        time = 60
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
end

if mods["space-exploration"] then
    data.raw.technology["advanced-pumpjacks-mk3"].prerequisites = { "advanced-pumpjacks", "se-rocket-science-pack" }
    data.raw.technology["advanced-pumpjacks-mk3"].unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "production-science-pack",  2 },
            { "utility-science-pack",     1 },
            { "se-rocket-science-pack",   1 },
        },
        time = 60
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
