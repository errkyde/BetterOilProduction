data:extend({
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
        mining_speed = 1.5,
        resource_drain_rate_percent = 80,
        energy_usage = "150kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 12 }
        },
        output_fluid_box = {
            volume = 5000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}}, flow_direction = "output" }
            }
        },
        radius_visualisation_picture = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack-base-shadow.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack-horsehead.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk2/pumpjack-horsehead-shadow.png",
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
        mining_speed = 2.5,
        resource_drain_rate_percent = 60,
        energy_usage = "200kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 20 }
        },
        output_fluid_box = {
            volume = 15000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}}, flow_direction = "output" }
            }
        },
        radius_visualisation_picture = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack-base-shadow.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack-horsehead.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-mk3/pumpjack-horsehead-shadow.png",
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
        allowed_effects = {"consumption", "productivity", "pollution"},
        mining_speed = 0.9,
        resource_drain_rate_percent = 35,
        energy_usage = "50kW",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 3 }
        },
        output_fluid_box = {
            volume = 5000,
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                { direction = defines.direction.north, positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}}, flow_direction = "output" }
            }
        },
        radius_visualisation_picture = {
            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack-radius-visualization.png",
            width = 12,
            height = 12
        },
        monitor_visualization_tint = {78, 173, 255},
        base_render_layer = "object",
        base_picture = {
            sheets = {
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack-base.png",
                    priority = "extra-high",
                    width = 261,
                    height = 273,
                    shift = util.by_pixel(-2.25, -4.75),
                    scale = 0.5
                },
                {
                    filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack-base-shadow.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack-horsehead.png",
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
                            filename = "__BetterOilProduction__/graphics/entity/better-pumpjack-eco/pumpjack-horsehead-shadow.png",
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
