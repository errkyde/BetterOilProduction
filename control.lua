local function is_space_surface(surface)
  if not surface or not surface.valid then return false end
  -- Heuristic: Space Age marks space surfaces with property 'space' or via name (e.g., "nauvis" is ground)
  if surface.name == "nauvis" then return false end
  return true
end

-- Spawn oil-rich asteroids on space surfaces when chunks are generated
script.on_event(defines.events.on_chunk_generated, function(event)
  local surface = event.surface
  if not is_space_surface(surface) then return end

  -- Simple probability per chunk
  if math.random() < 0.10 then
    local area = event.area
    local x = (area.left_top.x + area.right_bottom.x) / 2
    local y = (area.left_top.y + area.right_bottom.y) / 2

    -- Pick size with weights: medium 20%, small 40%, chunk 40%
    local r = math.random()
    local name
    if r < 0.2 then
      name = "medium-oil_rich-asteroid"
    elseif r < 0.6 then
      name = "small-oil_rich-asteroid"
    else
      name = "oil_rich-asteroid-chunk"
    end

    surface.create_entity{ name = name, position = { x, y }, force = "enemy" }
  end
end)


