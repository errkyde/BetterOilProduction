-- New recipe category exclusively for the hydrocarbon synthesizer
data:extend({
    {
        type = "recipe-category",
        name = "bop-space-synthesis",
    }
})

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
        subgroup = "space-platform-utility",
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
        subgroup = "extraction-machine",
        order = "z-c[bop-synthetic-crude]",
        stack_size = 100,
    },
    {
        type = "item",
        name = "bop-hydrocarbon-synthesizer",
        icons = {
            {
                icon = "__base__/graphics/icons/assembling-machine-2.png",
                icon_size = 64,
                tint = { r = 0.65, g = 0.40, b = 0.10, a = 1 },
            }
        },
        subgroup = "extraction-machine",
        order = "z-d[bop-hydrocarbon-synthesizer]",
        place_result = "bop-hydrocarbon-synthesizer",
        stack_size = 10,
    },
})

-- Entity: deep-copy assembling-machine-2 and retune for space synthesis
local synthesizer = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
synthesizer.name                    = "bop-hydrocarbon-synthesizer"
synthesizer.icons = {
    {
        icon = "__base__/graphics/icons/assembling-machine-2.png",
        icon_size = 64,
        tint = { r = 0.65, g = 0.40, b = 0.10, a = 1 },
    }
}
synthesizer.minable                 = { mining_time = 1, result = "bop-hydrocarbon-synthesizer" }
synthesizer.crafting_categories     = { "bop-space-synthesis" }
synthesizer.crafting_speed          = 1.0
synthesizer.module_slots            = 2
synthesizer.allowed_effects         = { "consumption", "speed", "productivity" }
synthesizer.heating_energy          = "100kW"
synthesizer.fluid_boxes_off_when_no_fluid_recipe = true
synthesizer.fluid_boxes = {
    {
        production_type = "input",
        volume = 1000,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south, position = { 0, 1 } }
        }
    }
}
data:extend({ synthesizer })

-- Recipes
data:extend({
    -- How to craft the machine itself
    {
        type = "recipe",
        name = "bop-hydrocarbon-synthesizer",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "assembling-machine-2", amount = 1  },
            { type = "item", name = "steel-plate",          amount = 15 },
            { type = "item", name = "advanced-circuit",     amount = 10 },
            { type = "item", name = "pipe",                 amount = 5  },
        },
        results = {
            { type = "item", name = "bop-hydrocarbon-synthesizer", amount = 1 }
        },
    },

    -- Space-side: hydrocarbon chunks + water -> synthetic crude (solid, rocketable)
    {
        type = "recipe",
        name = "bop-space-synthesis",
        category = "bop-space-synthesis",
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

    -- Planet-side: heat synthetic crude in a chemical plant -> crude oil (no fluid input needed)
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
            { type = "fluid", name = "crude-oil", amount = 500 }
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
        prerequisites = { "advanced-pumpjacks", "space-science-pack" },
        effects = {
            { type = "unlock-recipe", recipe = "bop-hydrocarbon-synthesizer" },
            { type = "unlock-recipe", recipe = "bop-space-synthesis"         },
            { type = "unlock-recipe", recipe = "bop-crude-from-synthetic"    },
        },
        unit = {
            count = 500,
            ingredients = {
                { "automation-science-pack",  1 },
                { "logistic-science-pack",    1 },
                { "chemical-science-pack",    1 },
                { "space-science-pack",       1 },
                { "metallurgic-science-pack", 1 },
            },
            time = 60,
        },
        order = "d-d",
    },
})
