local hit_effects = require("__base__.prototypes.entity.hit-effects")

data:extend({
    -- Better Pumpjack (tier 1)
    {
        type = "mining-drill",
        name = "better-pumpjack",
        icon = "__Better-Oil-Production__/graphics/icons/better-pumpjack.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack"},
        max_health = 400,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        damaged_trigger_effect = hit_effects.entity(),
        drawing_box_vertical_extension = 1,
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 3,
        allowed_effects = {"consumption", "speed", "productivity", "pollution"},
        mining_speed = 2.0,
        resource_drain_rate_percent = 100,
        energy_usage = "170kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 18 }
        },
        output_fluid_box = {
            volume = 2000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { flow_direction = "output", direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}} }
            }
        },
        radius_visualisation_picture = {
            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack/pumpjack-base-shadow.png",
                    width = 220,
                    height = 220,
                    scale = 0.5,
                    draw_as_shadow = true,
                    shift = util.by_pixel(6, 0.5)
                }
            }
        },
        graphics_set = {
            animation = {
                north = {
                    layers = {
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack/pumpjack-horsehead.png",
                            animation_speed = 0.5,
                            scale = 0.5,
                            line_length = 8,
                            width = 206,
                            height = 202,
                            frame_count = 40,
                            shift = util.by_pixel(-4, -24)
                        },
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack/pumpjack-horsehead-shadow.png",
                            animation_speed = 0.5,
                            draw_as_shadow = true,
                            line_length = 8,
                            width = 309,
                            height = 82,
                            frame_count = 40,
                            scale = 0.5,
                            shift = util.by_pixel(17.75, 14.5)
                        }
                    }
                }
            }
        },
        open_sound = {filename = "__base__/sound/open-close/pumpjack-open.ogg", volume = 0.5},
        close_sound = {filename = "__base__/sound/open-close/pumpjack-close.ogg", volume = 0.5},
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.7, audible_distance_modifier = 0.6},
            max_sounds_per_prototype = 3,
            fade_in_ticks = 4,
            fade_out_ticks = 10
        },
        fast_replaceable_group = "pumpjack",
        next_upgrade = "better-pumpjack-mk2",
        circuit_connector = circuit_connector_definitions["pumpjack"],
        circuit_wire_max_distance = default_circuit_wire_max_distance
    },

    -- Better Pumpjack Mk2 (tier 2)
    {
        type = "mining-drill",
        name = "better-pumpjack-mk2",
        icon = "__Better-Oil-Production__/graphics/icons/better-pumpjack-mk2.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack-mk2"},
        max_health = 800,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        damaged_trigger_effect = hit_effects.entity(),
        drawing_box_vertical_extension = 1,
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 4,
        allowed_effects = {"consumption", "speed", "productivity", "pollution"},
        mining_speed = 4.0,
        resource_drain_rate_percent = 100,
        energy_usage = "420kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 35 }
        },
        output_fluid_box = {
            volume = 4000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { flow_direction = "output", direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}} }
            }
        },
        radius_visualisation_picture = {
            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-mk2/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-mk2/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-mk2/pumpjack-base-shadow.png",
                    width = 220,
                    height = 220,
                    scale = 0.5,
                    draw_as_shadow = true,
                    shift = util.by_pixel(6, 0.5)
                }
            }
        },
        graphics_set = {
            animation = {
                north = {
                    layers = {
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-mk2/pumpjack-horsehead.png",
                            animation_speed = 0.5,
                            scale = 0.5,
                            line_length = 8,
                            width = 206,
                            height = 202,
                            frame_count = 40,
                            shift = util.by_pixel(-4, -24)
                        },
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-mk2/pumpjack-horsehead-shadow.png",
                            animation_speed = 0.5,
                            draw_as_shadow = true,
                            line_length = 8,
                            width = 309,
                            height = 82,
                            frame_count = 40,
                            scale = 0.5,
                            shift = util.by_pixel(17.75, 14.5)
                        }
                    }
                }
            }
        },
        open_sound = {filename = "__base__/sound/open-close/pumpjack-open.ogg", volume = 0.5},
        close_sound = {filename = "__base__/sound/open-close/pumpjack-close.ogg", volume = 0.5},
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.7, audible_distance_modifier = 0.6},
            max_sounds_per_prototype = 3,
            fade_in_ticks = 4,
            fade_out_ticks = 10
        },
        fast_replaceable_group = "pumpjack",
        circuit_connector = circuit_connector_definitions["pumpjack"],
        circuit_wire_max_distance = default_circuit_wire_max_distance
    },

    -- Eco-Friendly Pumpjack
    {
        type = "mining-drill",
        name = "better-pumpjack-eco",
        icon = "__Better-Oil-Production__/graphics/icons/better-pumpjack-eco.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "better-pumpjack-eco"},
        max_health = 400,
        resource_categories = {"basic-fluid"},
        corpse = "pumpjack-remnants",
        dying_explosion = "pumpjack-explosion",
        damaged_trigger_effect = hit_effects.entity(),
        drawing_box_vertical_extension = 1,
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        resource_searching_radius = 0.49,
        vector_to_place_result = {0, 0},
        module_slots = 3,
        allowed_effects = {"consumption", "productivity", "pollution"},
        mining_speed = 0.5,
        resource_drain_rate_percent = 20,
        energy_usage = "55kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 2 }
        },
        output_fluid_box = {
            volume = 1000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { flow_direction = "output", direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}} }
            }
        },
        radius_visualisation_picture = {
            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-eco/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-eco/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-eco/pumpjack-base-shadow.png",
                    width = 220,
                    height = 220,
                    scale = 0.5,
                    draw_as_shadow = true,
                    shift = util.by_pixel(6, 0.5)
                }
            }
        },
        graphics_set = {
            animation = {
                north = {
                    layers = {
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-eco/pumpjack-horsehead.png",
                            animation_speed = 0.5,
                            scale = 0.5,
                            line_length = 8,
                            width = 206,
                            height = 202,
                            frame_count = 40,
                            shift = util.by_pixel(-4, -24)
                        },
                        {
                            priority = "high",
                            filename = "__Better-Oil-Production__/graphics/entity/better-pumpjack-eco/pumpjack-horsehead-shadow.png",
                            animation_speed = 0.5,
                            draw_as_shadow = true,
                            line_length = 8,
                            width = 309,
                            height = 82,
                            frame_count = 40,
                            scale = 0.5,
                            shift = util.by_pixel(17.75, 14.5)
                        }
                    }
                }
            }
        },
        open_sound = {filename = "__base__/sound/open-close/pumpjack-open.ogg", volume = 0.5},
        close_sound = {filename = "__base__/sound/open-close/pumpjack-close.ogg", volume = 0.5},
        working_sound = {
            sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.7, audible_distance_modifier = 0.6},
            max_sounds_per_prototype = 3,
            fade_in_ticks = 4,
            fade_out_ticks = 10
        },
        fast_replaceable_group = "pumpjack",
        circuit_connector = circuit_connector_definitions["pumpjack"],
        circuit_wire_max_distance = default_circuit_wire_max_distance
    }
})
