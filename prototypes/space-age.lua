-- Items
data:extend({
    {
        type = "item",
        name = "bop-hydrocarbon-chunk",
        icons = {
            {
                icon = "__space-age__/graphics/icons/carbonic-asteroid-chunk.png",
                icon_size = 64,
                tint = { r = 0.45, g = 0.30, b = 0.10, a = 1 },
            }
        },
        subgroup = "intermediate-product",
        order = "z-a[bop-hydrocarbon-chunk]",
        stack_size = 200,
    },
    {
        type = "item",
        name = "bop-synthetic-crude",
        icons = {
            {
                icon = "__space-age__/graphics/icons/carbonic-asteroid-chunk.png",
                icon_size = 64,
                tint = { r = 0.15, g = 0.08, b = 0.03, a = 1 },
            }
        },
        subgroup = "intermediate-product",
        order = "z-c[bop-synthetic-crude]",
        stack_size = 100,
    },
})

-- Recipes
data:extend({
    -- Space-side: hydrocarbon chunks + water -> synthetic crude in any assembling machine
    {
        type = "recipe",
        name = "bop-space-synthesis",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 15,
        ingredients = {
            { type = "item",  name = "bop-hydrocarbon-chunk", amount = 5   },
            { type = "fluid", name = "water",                 amount = 100 },
        },
        results = {
            { type = "item", name = "bop-synthetic-crude", amount = 1 }
        },
    },

    -- Planet-side: heat synthetic crude in a chemical plant -> crude oil
    {
        type = "recipe",
        name = "bop-crude-from-synthetic",
        category = "chemistry",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "bop-synthetic-crude", amount = 1 },
        },
        results = {
            { type = "fluid", name = "crude-oil", amount = 300 }
        },
    },
})

-- Tips and tricks: space synthesis chain
data:extend({
    {
        type = "tips-and-tricks-item",
        name = "bop-space-synthesis",
        category = "bop-oil-production",
        order = "d",
        trigger = {
            type       = "research",
            technology = "bop-space-oil-synthesis",
        },
    },
})

-- Technology
data:extend({
    {
        type = "technology",
        name = "bop-space-oil-synthesis",
        icon = "__space-age__/graphics/technology/space-platform.png",
        icon_size = 256,
        prerequisites = { "better-pumpjack", "space-science-pack" },
        effects = {
            { type = "unlock-recipe", recipe = "bop-space-synthesis"      },
            { type = "unlock-recipe", recipe = "bop-crude-from-synthetic" },
        },
        unit = {
            count = 500,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "space-science-pack",      1 },
            },
            time = 60,
        },
        order = "d-d",
    },
})
