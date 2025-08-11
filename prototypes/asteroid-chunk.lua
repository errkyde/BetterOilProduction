if mods["space-age"] then
  -- Oil asteroid data following Space Age mod structure
  local oil_asteroid_data = {
    oil_rich = {
      order = "e",
      mass = {0, 200000, 500000},
      max_health = {0, 100, 400},
      resistances = {
        physical = {
          decrease = {0, 0, 0},
          percent = {0, 0, 10}
        },
        explosion = {
          decrease = {0, 0, 0},
          percent = {0, 50, 30}
        },
        laser = {
          decrease = {0, 0, 0},
          percent = {0, 20, 90}
        }
      },
      shading_data = {
        normal_strength = 1.1,
        light_width = 0,
        brightness = 0.8,
        specular_strength = 2.2,
        specular_power = 1.8,
        specular_purity = 0.3,
        sss_contrast = 1,
        sss_amount = 0.1,
        lights = {
          { color = {0.9,0.8,0.6}, direction = {0.7,0.6,-1} },
          { color = {0.3,0.2,0.1}, direction = {-0.72,-0.46,1} },
          { color = {0.1,0.1,0.1}, direction = {-0.4,-0.25,-0.5} },
        },
        ambient_light = {0.02, 0.015, 0.01}
      }
    }
  }

  -- Only define sizes you have art for
  local asteroid_sizes = {"chunk", "small", "medium"}
  local collision_radiuses = {0.4, 0.5, 1}
  local graphics_scale = {0.5, 0.5, 0.5}
  local sizes_resolution = {{50,1}, {128,1}, {230,0}}
  local letter = {"a","b","c"}

  -- Use your custom textures
  local function oil_asteroid_variation(size_name, index, scale, size)
    local idx = tostring(index)
    return {
      color_texture = {
        filename = "__BetterOilProduction__/graphics/entity/oil-asteroid/"..size_name.."/"..size_name.."-"..idx..".png",
        size = sizes_resolution[size][1],
        scale = scale
      },
      shadow_shift = { 0.25 * size, 0.25 * size },
      normal_map = {
        filename = "__BetterOilProduction__/graphics/entity/oil-asteroid/"..size_name.."/"..size_name.."-"..idx.."-normal.png",
        premul_alpha = false,
        size = sizes_resolution[size][1],
        scale = scale
      },
      roughness_map = {
        filename = "__BetterOilProduction__/graphics/entity/oil-asteroid/"..size_name.."/"..size_name.."-"..idx.."-roughness.png",
        premul_alpha = false,
        size = sizes_resolution[size][1],
        scale = scale
      }
    }
  end

  local function oil_asteroid_graphics_set(rotation_speed, shading_data, variations)
    local result = table.deepcopy(shading_data)
    result.rotation_speed = rotation_speed
    result.variations = variations
    return result
  end

  -- Create oil asteroids for each size
  for asteroid_size, asteroid_size_name in pairs(asteroid_sizes) do
    for asteroid_type, asteroid_data in pairs(oil_asteroid_data) do
      local current_graphics_scale = graphics_scale[asteroid_size]
      local collision_radius = collision_radiuses[asteroid_size]
      local selection_radius = collision_radius * 1.1 + 0.1
      local max_health = asteroid_data.max_health[asteroid_size] > 0 and asteroid_data.max_health[asteroid_size] or nil
      local asteroid_name, resistances
      local dying_trigger_effects = {
        {
          type = asteroid_size_name == "chunk" and "create-entity" or "create-explosion",
          -- Reuse metallic asteroid explosion from Space Age
          entity_name = "metallic-asteroid-explosion-"..asteroid_size,
        }
      }

      if asteroid_size_name == "chunk" then
        asteroid_name = asteroid_type .. "-asteroid-chunk"
      else
        asteroid_name = asteroid_size_name .. "-"..asteroid_type.."-asteroid"
        local spread = collision_radius * 0.5

        if asteroid_size == 2 then -- small -> create chunks
          table.insert(dying_trigger_effects, {
            type = "create-asteroid-chunk",
            asteroid_name = asteroid_type.."-asteroid-chunk",
            offset_deviation = {{-spread, -spread}, {spread, spread}},
            offsets = {
              {-spread/2, -spread/4},
              {spread/2, -spread/4}
            }
          })
        elseif asteroid_size == 3 then -- medium -> create small
          table.insert(dying_trigger_effects, {
            type = "create-entity",
            entity_name = asteroid_sizes[asteroid_size-1] .. "-"..asteroid_type.."-asteroid",
            offset_deviation = {{-spread, -spread}, {spread, spread}},
            offsets = {
              {-spread, -spread/4},
              {0, -spread/2},
              {spread, -spread/4}
            }
          })
        end

        -- Generate resistances for this size
        resistances = {}
        for damage_name, _ in pairs(data.raw["damage-type"]) do
          if asteroid_data.resistances[damage_name] then
            table.insert(resistances, {
              type = damage_name,
              decrease = asteroid_data.resistances[damage_name].decrease[asteroid_size],
              percent = asteroid_data.resistances[damage_name].percent[asteroid_size]
            })
          else
            if damage_name ~= "impact" and damage_name ~= "poison" and damage_name ~= "acid" then
              table.insert(resistances, { type = damage_name, percent = 100 })
            end
          end
        end
      end

      -- Create variations based on your available art (3 each)
      local variations = {}
      local count = 3
      for i = 1, count do
        table.insert(variations, oil_asteroid_variation(asteroid_size_name, i, current_graphics_scale, asteroid_size))
      end

      -- Use your icons
      local icon_by_size = {
        chunk = "__BetterOilProduction__/graphics/icons/asteroid-oil-chunk-chunk.png",
        small = "__BetterOilProduction__/graphics/icons/asteroid-oil-chunk-small.png",
        medium = "__BetterOilProduction__/graphics/icons/asteroid-oil-chunk-medium.png",
      }

      data:extend({
        {
          type = asteroid_size_name == "chunk" and "asteroid-chunk" or "asteroid",
          name = asteroid_name,
          overkill_fraction = asteroid_size_name ~= "chunk" and 0.01 or nil,
          localised_description = {"entity-description.oil_rich-asteroid"},
          icon = icon_by_size[asteroid_size_name],
          icon_size = 64,
          selection_box = asteroid_size_name ~= "chunk" and {{-selection_radius, -selection_radius}, {selection_radius, selection_radius}} or nil,
          collision_box = asteroid_size_name ~= "chunk" and {{-collision_radius, -collision_radius}, {collision_radius, collision_radius}} or nil,
          collision_mask = asteroid_size_name ~= "chunk" and {layers={object=true}, not_colliding_with_itself=true} or nil,
          graphics_set = oil_asteroid_graphics_set(0.0003 * (6 - asteroid_size), asteroid_data.shading_data, variations),
          dying_trigger_effect = dying_trigger_effects,
          subgroup = asteroid_size_name == "chunk" and "space-material" or "space-environment",
          order = asteroid_data.order .. "["..asteroid_type.."]-"..letter[asteroid_size].."["..asteroid_size_name.."]",

          -- asteroid-chunk properties
          minable = asteroid_size_name == "chunk" and {
            mining_time = 0.2,
            result = asteroid_name,
            mining_particle = "metallic-asteroid-chunk-particle-medium"
          } or nil,

          -- asteroid properties
          flags = asteroid_size_name ~= "chunk" and {"placeable-enemy", "placeable-off-grid", "not-repairable", "not-on-map"} or nil,
          max_health = asteroid_size_name ~= "chunk" and asteroid_data.max_health[asteroid_size] or nil,
          mass = asteroid_size_name ~= "chunk" and asteroid_data.mass[asteroid_size] or nil,
          resistances = resistances,
        }
      })
    end
  end
end
