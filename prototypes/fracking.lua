-- Recipe categories
data:extend({
    { type = "recipe-category", name = "bop-fracking" },
    { type = "recipe-category", name = "bop-eor"      },
})

-- Polymer Slurry — a coal-tar derived compound used for enhanced oil recovery.
-- Coal-tar chemistry: petroleum gas + sulfuric acid catalyst + coal carbon source.
-- 2 fluid inputs + 1 solid — fits a standard chemical plant (max 2 fluid ports).
-- Space Age adds a Refined variant using solid fuel instead of coal (data-updates.lua).
data:extend({
    {
        type = "fluid",
        name = "bop-polymer-slurry",
        icons = {
            {
                icon      = "__base__/graphics/icons/fluid/heavy-oil.png",
                icon_size = 64,
                tint      = { r = 0.25, g = 0.65, b = 0.20, a = 1.0 },
            }
        },
        base_color          = { r = 0.25, g = 0.60, b = 0.15 },
        flow_color          = { r = 0.35, g = 0.75, b = 0.20 },
        default_temperature = 25,
        max_temperature     = 100,
        subgroup            = "fluid",
        order               = "f[bop-polymer-slurry]",
    },
    {
        type             = "recipe",
        name             = "bop-polymer-slurry",
        category         = "chemistry",
        enabled          = false,
        energy_required  = 8,
        icons = {
            {
                icon      = "__base__/graphics/icons/fluid/heavy-oil.png",
                icon_size = 64,
                tint      = { r = 0.25, g = 0.65, b = 0.20, a = 1.0 },
            }
        },
        ingredients = {
            { type = "fluid", name = "petroleum-gas", amount = 80 },
            { type = "fluid", name = "sulfuric-acid", amount = 40 },
            { type = "item",  name = "coal",          amount = 20 },
        },
        results = {
            { type = "fluid", name = "bop-polymer-slurry", amount = 100 },
        },
    },
})

-- Items
data:extend({
    {
        type = "item",
        name = "bop-fracking-station",
        icons = {
            { icon = "__base__/graphics/icons/pumpjack.png",             icon_size = 64 },
            { icon = "__base__/graphics/icons/fluid/steam.png",          icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-2.png", icon_size = 64, scale = 0.5, shift = { -9, 10 }, tint = { r=0.85, g=0.30, b=0.12, a=1 } },
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
            { icon = "__base__/graphics/icons/pumpjack.png",             icon_size = 64 },
            { icon = "__base__/graphics/icons/fluid/crude-oil.png",      icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.5, shift = { -9, 10 }, tint = { r=0.12, g=0.50, b=0.78, a=1 } },
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
    { icon = "__base__/graphics/icons/pumpjack.png",             icon_size = 64 },
    { icon = "__base__/graphics/icons/fluid/steam.png",          icon_size = 64, scale = 0.5, shift = {  9, -9 } },
    { icon = "__base__/graphics/icons/assembling-machine-2.png", icon_size = 64, scale = 0.5, shift = { -9, 10 }, tint = { r=0.85, g=0.30, b=0.12, a=1 } },
}
fracking_station.minable           = { mining_time = 1, result = "bop-fracking-station" }
fracking_station.crafting_categories = { "bop-fracking" }
fracking_station.fixed_recipe      = "bop-fracking-process"
fracking_station.crafting_speed    = 1.0
fracking_station.module_slots      = 0
fracking_station.allowed_effects   = {}
fracking_station.energy_usage      = "200kW"
fracking_station.heating_energy    = "75kW"
fracking_station.map_color         = { r=0.80, g=0.25, b=0.10 }
fracking_station.alert_icon_shift  = util.by_pixel(0, -12)
fracking_station.working_sound = {
    sound = { filename = "__base__/sound/boiler.ogg", volume = 0.6, audible_distance_modifier = 0.5 },
    max_sounds_per_prototype = 3,
    fade_in_ticks = 4,
    fade_out_ticks = 20,
}
fracking_station.open_sound  = { filename = "__base__/sound/open-close/fluid-open.ogg",  volume = 0.5 }
fracking_station.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.5 }
fracking_station.graphics_set = fracking_station.graphics_set or {}
fracking_station.graphics_set.working_visualisations = {
    {   -- animated fire/glow when active
        fadeout = true,
        effect = "none",
        animation = {
            filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 40,
            height = 81,
            frame_count = 60,
            line_length = 10,
            animation_speed = 0.5,
            scale = 0.5,
            shift = util.by_pixel(0, -16),
        },
    },
    {   -- radial ambient glow
        fadeout = true,
        effect = "none",
        animation = {
            filename = "__base__/graphics/entity/electric-furnace/electric-furnace-light.png",
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 202,
            height = 202,
            frame_count = 1,
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            tint = { r=0.80, g=0.25, b=0.10, a=0.6 },
        },
    },
}

-- Use assembler2pipepictures() directly — this is the same function vanilla am2 calls,
-- so it always returns the correct directional stub sprites regardless of mod load order.
fracking_station.fluid_boxes = {
    {
        production_type = "input",
        volume = 1000,
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        -- secondary_draw_orders mirrors vanilla am2: north = -1 puts the pipe behind the
        -- machine body when facing north (same convention used by base assembling-machine-2).
        secondary_draw_orders = { north = -1 },
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } },
            { flow_direction = "input", direction = defines.direction.east,  position = { 1,  0 } },
            { flow_direction = "input", direction = defines.direction.south, position = { 0,  1 } },
            { flow_direction = "input", direction = defines.direction.west,  position = {-1,  0 } },
        }
    }
}
data:extend({ fracking_station })

local eor_injector = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
eor_injector.name              = "bop-eor-injector"
eor_injector.icons = {
    { icon = "__base__/graphics/icons/pumpjack.png",             icon_size = 64 },
    { icon = "__base__/graphics/icons/fluid/crude-oil.png",      icon_size = 64, scale = 0.5, shift = {  9, -9 } },
    { icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.5, shift = { -9, 10 }, tint = { r=0.12, g=0.50, b=0.78, a=1 } },
}
eor_injector.minable           = { mining_time = 1, result = "bop-eor-injector" }
eor_injector.crafting_categories = { "bop-eor" }
-- No fixed_recipe: player chooses from steam / light-oil / polymer-slurry process recipes.
eor_injector.crafting_speed    = 1.0
eor_injector.module_slots      = 2
eor_injector.allowed_effects   = { "consumption", "pollution" }
eor_injector.energy_usage      = "500kW"
eor_injector.heating_energy    = "100kW"
eor_injector.fluid_boxes_off_when_no_fluid_recipe = true
eor_injector.map_color         = { r=0.10, g=0.45, b=0.70 }
eor_injector.alert_icon_shift  = util.by_pixel(0, -12)
eor_injector.working_sound = {
    sound = {
        variations = {
            { filename = "__base__/sound/chemical-plant-1.ogg", volume = 0.5 },
            { filename = "__base__/sound/chemical-plant-2.ogg", volume = 0.5 },
            { filename = "__base__/sound/chemical-plant-3.ogg", volume = 0.5 },
        },
        audible_distance_modifier = 0.5,
    },
    max_sounds_per_prototype = 3,
    fade_in_ticks = 4,
    fade_out_ticks = 20,
}
eor_injector.open_sound  = { filename = "__base__/sound/open-close/fluid-open.ogg",  volume = 0.5 }
eor_injector.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.5 }
eor_injector.graphics_set = eor_injector.graphics_set or {}
eor_injector.graphics_set.working_visualisations = {
    {   -- directional glow (oil-refinery light sprite, north frame)
        fadeout = true,
        effect = "none",
        animation = {
            filename = "__base__/graphics/entity/oil-refinery/oil-refinery-light.png",
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 321,
            height = 205,
            frame_count = 1,
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            tint = { r=0.10, g=0.45, b=0.70, a=0.7 },
        },
    },
    {   -- ambient glow
        fadeout = true,
        effect = "none",
        animation = {
            filename = "__base__/graphics/entity/electric-furnace/electric-furnace-light.png",
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 202,
            height = 202,
            frame_count = 1,
            scale = 0.6,
            shift = util.by_pixel(0, 0),
            tint = { r=0.10, g=0.45, b=0.70, a=0.5 },
        },
    },
}

-- Use assembler3pipepictures() directly — same function vanilla am3 calls.
eor_injector.fluid_boxes = {
    {
        production_type = "input",
        volume = 2000,
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        -- secondary_draw_orders mirrors vanilla am3: north = -1 puts the pipe behind the
        -- machine body when facing north.
        secondary_draw_orders = { north = -1 },
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } },
            { flow_direction = "input", direction = defines.direction.east,  position = { 1,  0 } },
            { flow_direction = "input", direction = defines.direction.south, position = { 0,  1 } },
            { flow_direction = "input", direction = defines.direction.west,  position = {-1,  0 } },
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
        enabled = false,
        energy_required = 1,
        icons = {
            { icon = "__base__/graphics/icons/fluid/steam.png",          icon_size = 64 },
            { icon = "__base__/graphics/icons/pumpjack.png",             icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-2.png", icon_size = 64, scale = 0.45, shift = { -9, 10 }, tint = { r=0.85, g=0.30, b=0.12, a=1 } },
        },
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
        enabled = false,
        energy_required = 1,
        icons = {
            { icon = "__base__/graphics/icons/fluid/light-oil.png",      icon_size = 64 },
            { icon = "__base__/graphics/icons/fluid/crude-oil.png",      icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.45, shift = { -9, 10 }, tint = { r=0.12, g=0.50, b=0.78, a=1 } },
        },
        ingredients = {
            { type = "fluid", name = "light-oil", amount = 100 },
        },
        results = {},
        hide_from_player_crafting = true,
    },
    -- Steam: cheap but ~3× slower than light oil (~3 h per fully-depleted field).
    {
        type = "recipe",
        name = "bop-eor-steam-process",
        category = "bop-eor",
        enabled = false,
        energy_required = 1,
        icons = {
            { icon = "__base__/graphics/icons/fluid/steam.png",         icon_size = 64 },
            { icon = "__base__/graphics/icons/fluid/crude-oil.png",      icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.45, shift = { -9, 10 }, tint = { r=0.12, g=0.50, b=0.78, a=1 } },
        },
        ingredients = {
            { type = "fluid", name = "steam", amount = 200 },
        },
        results = {},
        hide_from_player_crafting = true,
    },
    -- Polymer Slurry: fastest option (~20 min per field) but expensive to produce.
    {
        type = "recipe",
        name = "bop-eor-polymer-process",
        category = "bop-eor",
        enabled = false,
        energy_required = 1,
        icons = {
            { icon = "__base__/graphics/icons/fluid/heavy-oil.png",      icon_size = 64, tint = { r=0.45, g=0.80, b=0.35, a=1 } },
            { icon = "__base__/graphics/icons/fluid/crude-oil.png",      icon_size = 64, scale = 0.5, shift = {  9, -9 } },
            { icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.45, shift = { -9, 10 }, tint = { r=0.12, g=0.50, b=0.78, a=1 } },
        },
        ingredients = {
            { type = "fluid", name = "bop-polymer-slurry", amount = 50 },
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
            { type = "item", name = "refined-concrete",      amount = 20 },
            { type = "item", name = "electric-engine-unit",  amount = 8  },
            { type = "item", name = "steel-plate",           amount = 10 },
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
        prerequisites = { "advanced-pumpjacks-mk2", "bop-fracking" },
        effects = {
            { type = "unlock-recipe", recipe = "bop-eor-injector"        },
            { type = "unlock-recipe", recipe = "bop-eor-process"         },
            { type = "unlock-recipe", recipe = "bop-eor-steam-process"   },
            { type = "unlock-recipe", recipe = "bop-eor-polymer-process" },
            { type = "unlock-recipe", recipe = "bop-polymer-slurry"      },
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
