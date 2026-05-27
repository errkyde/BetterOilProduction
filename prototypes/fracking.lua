-- Recipe categories
data:extend({
    { type = "recipe-category", name = "bop-fracking" },
    { type = "recipe-category", name = "bop-eor"      },
})

-- Items
data:extend({
    {
        type = "item",
        name = "bop-fracking-station",
        icons = {
            {
                icon = "__base__/graphics/icons/assembling-machine-2.png",
                icon_size = 64,
                tint = { r = 0.80, g = 0.25, b = 0.10, a = 1 },
            }
        },
        subgroup = "extraction-machine",
        order = "b[fluids]-b[pumpjack]-e[fracking]",
        place_result = "bop-fracking-station",
        stack_size = 10,
    },
    {
        type = "item",
        name = "bop-eor-injector",
        icons = {
            {
                icon = "__base__/graphics/icons/assembling-machine-3.png",
                icon_size = 64,
                tint = { r = 0.10, g = 0.45, b = 0.70, a = 1 },
            }
        },
        subgroup = "extraction-machine",
        order = "b[fluids]-b[pumpjack]-f[eor]",
        place_result = "bop-eor-injector",
        stack_size = 10,
    },
})

-- Entities
local fracking_station = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
fracking_station.name              = "bop-fracking-station"
fracking_station.icons = {
    {
        icon = "__base__/graphics/icons/assembling-machine-2.png",
        icon_size = 64,
        tint = { r = 0.80, g = 0.25, b = 0.10, a = 1 },
    }
}
fracking_station.minable           = { mining_time = 1, result = "bop-fracking-station" }
fracking_station.crafting_categories = { "bop-fracking" }
fracking_station.fixed_recipe      = "bop-fracking-process"
fracking_station.crafting_speed    = 1.0
fracking_station.module_slots      = 0
fracking_station.energy_usage      = "200kW"
fracking_station.heating_energy    = "75kW"
fracking_station.fluid_boxes_off_when_no_fluid_recipe = true
fracking_station.fluid_boxes = {
    {
        production_type = "input",
        volume = 1000,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south, position = { 0, 1 } }
        }
    }
}
data:extend({ fracking_station })

local eor_injector = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
eor_injector.name              = "bop-eor-injector"
eor_injector.icons = {
    {
        icon = "__base__/graphics/icons/assembling-machine-3.png",
        icon_size = 64,
        tint = { r = 0.10, g = 0.45, b = 0.70, a = 1 },
    }
}
eor_injector.minable           = { mining_time = 1, result = "bop-eor-injector" }
eor_injector.crafting_categories = { "bop-eor" }
eor_injector.fixed_recipe      = "bop-eor-process"
eor_injector.crafting_speed    = 1.0
eor_injector.module_slots      = 2
eor_injector.allowed_effects   = { "speed", "consumption", "pollution" }
eor_injector.energy_usage      = "500kW"
eor_injector.heating_energy    = "100kW"
eor_injector.fluid_boxes_off_when_no_fluid_recipe = true
eor_injector.fluid_boxes = {
    {
        production_type = "input",
        volume = 2000,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south, position = { 0, 1 } }
        }
    }
}
data:extend({ eor_injector })

-- Process recipes (fluid in, no output — script handles the actual effect)
data:extend({
    {
        type = "recipe",
        name = "bop-fracking-process",
        category = "bop-fracking",
        -- Always enabled: the station item is still research-locked; this just lets the machine
        -- run once placed (avoids "does nothing" if research state is inconsistent).
        enabled = true,
        energy_required = 1,
        icon = "__base__/graphics/icons/assembling-machine-2.png",
        icon_size = 64,
        ingredients = {
            { type = "fluid", name = "steam", amount = 100 },
        },
        results = {},
        hide_from_player_crafting = true,
    },
    {
        type = "recipe",
        name = "bop-eor-process",
        category = "bop-eor",
        enabled = true,
        energy_required = 1,
        icon = "__base__/graphics/icons/assembling-machine-3.png",
        icon_size = 64,
        ingredients = {
            { type = "fluid", name = "light-oil", amount = 100 },
        },
        results = {},
        hide_from_player_crafting = true,
    },
})

-- Crafting recipes (how to build the machines)
data:extend({
    {
        type = "recipe",
        name = "bop-fracking-station",
        enabled = false,
        energy_required = 8,
        ingredients = {
            { type = "item", name = "pumpjack",         amount = 1  },
            { type = "item", name = "steel-plate",      amount = 20 },
            { type = "item", name = "advanced-circuit", amount = 10 },
            { type = "item", name = "pipe",             amount = 5  },
            { type = "item", name = "iron-gear-wheel",  amount = 10 },
        },
        results = {
            { type = "item", name = "bop-fracking-station", amount = 1 }
        },
    },
    {
        type = "recipe",
        name = "bop-eor-injector",
        enabled = false,
        energy_required = 15,
        ingredients = {
            { type = "item", name = "assembling-machine-3",  amount = 1  },
            { type = "item", name = "processing-unit",       amount = 15 },
            { type = "item", name = "productivity-module",   amount = 3  },
            { type = "item", name = "electric-engine-unit",  amount = 8  },
            { type = "item", name = "steel-plate",           amount = 20 },
            { type = "item", name = "pipe",                  amount = 10 },
        },
        results = {
            { type = "item", name = "bop-eor-injector", amount = 1 }
        },
    },
})

-- Technologies
data:extend({
    {
        type = "technology",
        name = "bop-fracking",
        icon = "__base__/graphics/technology/oil-processing.png",
        icon_size = 256,
        prerequisites = { "advanced-oil-processing", "advanced-pumpjacks" },
        effects = {
            { type = "unlock-recipe", recipe = "bop-fracking-station"  },
            { type = "unlock-recipe", recipe = "bop-fracking-process"  },
        },
        unit = {
            count = 300,
            ingredients = {
                { "automation-science-pack",  1 },
                { "logistic-science-pack",    1 },
                { "chemical-science-pack",    1 },
                { "production-science-pack",  1 },
            },
            time = 45,
        },
        order = "d-e",
    },
    {
        type = "technology",
        name = "bop-eor",
        icon = "__base__/graphics/technology/fluid-handling.png",
        icon_size = 256,
        prerequisites = { "advanced-pumpjacks-mk3", "bop-fracking" },
        effects = {
            { type = "unlock-recipe", recipe = "bop-eor-injector" },
            { type = "unlock-recipe", recipe = "bop-eor-process"  },
        },
        unit = {
            count = 750,
            ingredients = {
                { "automation-science-pack",  1 },
                { "logistic-science-pack",    1 },
                { "chemical-science-pack",    1 },
                { "production-science-pack",  1 },
                { "utility-science-pack",     1 },
            },
            time = 60,
        },
        order = "d-f",
    },
})
