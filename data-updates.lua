local function add_fluid_filter(entity, new_filter)
  if not entity.fluid_box or not entity.fluid_box.filter then return end

  if type(entity.fluid_box.filter) == "string" then
    if entity.fluid_box.filter ~= new_filter then
      entity.fluid_box.filter = {entity.fluid_box.filter, new_filter}
    end
  elseif type(entity.fluid_box.filter) == "table" then
    for _, filter in pairs(entity.fluid_box.filter) do
      if filter == new_filter then return end
    end
    table.insert(entity.fluid_box.filter, new_filter)
  end
end

local function add_resource_category(entity, new_category)
  entity.resource_categories = entity.resource_categories or {}
  for _, cat in pairs(entity.resource_categories) do
    if cat == new_category then return end
  end
  table.insert(entity.resource_categories, new_category)
end

-- Space Age Integration
if mods["space-age"] then
  -- prototypes are loaded in data.lua already

  -- Add to collector filter (only for chunks)
  local collector = data.raw["asteroid-collector"] and data.raw["asteroid-collector"]["asteroid-collector"]
  if collector then
    collector.collection_filter = collector.collection_filter or {}
    -- Use the chunk prototype name we created
    table.insert(collector.collection_filter, "oil_rich-asteroid-chunk")
  end
end