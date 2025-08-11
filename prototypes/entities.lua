data:extend({
    -- Coal Refinery
    {
        type = "assembling-machine",
        name = "coal-refinery",
        icon = "__BetterOilProduction__/graphics/icons/coal-refinery.png",
        icon_size = 64,
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 2, result = "coal-refinery"},
        max_health = 450,
        corpse = "big-remnants",
        dying_explosion = "big-explosion",
        resistances = {
            {type = "fire", percent = 70},
        },
        collision_box = {{-2.0, -2.0}, {2.0, 2.0}},
        selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
        crafting_categories = {"oil-processing"},
        crafting_speed = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = 20
        },
        energy_usage = "300kW",
        fluid_boxes = {
            {
                production_type = "input",
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = -1,
                pipe_connections = {{type = "input", position = {0, -3}}}
            },
            off_when_no_fluid_recipe = true
        },
        animation = {
            filename = "__BetterOilProduction__/graphics/entity/coal-refinery.png",
            width = 160,
            height = 160,
            frame_count = 1,
            shift = {0, 0},
            scale = 1
        },
        working_visualisations = {
            {
                animation = {
                    filename = "__base__/graphics/entity/fire-smoke/fire-smoke.png",
                    priority = "high",
                    width = 32,
                    height = 32,
                    frame_count = 60,
                    line_length = 8,
                    animation_speed = 0.5,
                    shift = {0, -2.0},
                    draw_as_glow = true
                },
                light = {intensity = 1, size = 8, color = {r = 1.0, g = 0.5, b = 0.0}}
            }
        },
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        working_sound = {
            sound = {
                {filename = "__base__/sound/oil-refinery.ogg", volume = 0.8}
            },
            apparent_volume = 1.5
        },
        module_specification = {
            module_slots = 3,
            module_info_icon_shift = {0, 0.8},
            module_info_multi_row_initial_height_modifier = -0.3
        },
        allowed_effects = {"consumption", "speed", "productivity", "pollution"}
    },

    -- Better Pumpjack MK2
    {
        type = "mining-drill",
        name = "better-pumpjack-mk2",
        icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-mk2.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack-mk2"},
        max_health = 400,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 3,
        allowed_effects = {"consumption", "speed", "productivity", "pollution"},
        mining_speed = 2.0,
        energy_usage = "150kW",
        resource_draining = 0.7,
        pollution = 17,
        mining_area = {{-1.0, -1.0}, {1.0, 1.0}},
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = 0.2,
            buffer_capacity = "100kJ"
        },
        fluid_box = {
            base_area = 5,
            pipe_connections = {{position = {0, -2}}},
            production_type = "output",
            pipe_covers = pipecoverspictures(),
            filter = "crude-oil"
        },
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.6},
            apparent_volume = 1.5
        },
        animation = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack.png",
            width = 110,
            height = 110,
            frame_count = 1,
            line_length = 1,
            shift = {0, 0},
            animation_speed = 0.5
        },
        quality_module_tier = 3
    },

    -- Better Pumpjack MK3
    {
        type = "mining-drill",
        name = "better-pumpjack-mk3",
        icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-mk3.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack-mk3"},
        max_health = 800,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 4,
        allowed_effects = {"consumption", "speed", "productivity", "pollution"},
        mining_speed = 3.0,
        energy_usage = "200kW",
        resource_draining = 0.5,
        pollution = 30,
        mining_area = {{-1.0, -1.0}, {1.0, 1.0}},
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = 0.4,
            buffer_capacity = "200kJ"
        },
        fluid_box = {
            base_area = 15,
            pipe_connections = {{position = {0, -2}}},
            production_type = "output",
            pipe_covers = pipecoverspictures(),
            filter = "crude-oil"
        },
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.6},
            apparent_volume = 1.5
        },
        animation = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack.png",
            width = 110,
            height = 110,
            frame_count = 1,
            line_length = 1,
            shift = {0, 0},
            animation_speed = 0.5
        },
        quality_module_tier = 5
    },

    -- Better Pumpjack ECO
    {
        type = "mining-drill",
        name = "better-pumpjack-eco",
        icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-eco.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack-eco"},
        max_health = 400,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 3,
        allowed_effects = {"consumption", "speed", "pollution"},
        mining_speed = 0.9,
        energy_usage = "50kW",
        resource_draining = 0.3,
        pollution = 17,
        mining_area = {{-1.0, -1.0}, {1.0, 1.0}},
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = 0.05,
            buffer_capacity = "50kJ"
        },
        fluid_box = {
            base_area = 5,
            pipe_connections = {{position = {0, -2}}},
            production_type = "output",
            pipe_covers = pipecoverspictures(),
            filter = "crude-oil"
        },
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.6},
            apparent_volume = 1.5
        },
        animation = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack.png",
            width = 110,
            height = 110,
            frame_count = 1,
            line_length = 1,
            shift = {0, 0},
            animation_speed = 0.5
        }
    }
})
