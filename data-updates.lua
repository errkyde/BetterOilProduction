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

if mods["space-age"] then
  local pumpjacks = {
    "better-pumpjack-mk2",
    "better-pumpjack-mk3",
    "better-pumpjack-eco"
  }

  for _, name in pairs(pumpjacks) do
    local entity = data.raw["mining-drill"][name]
    if entity then
      -- Space Age Fluids einfügen:
      add_fluid_filter(entity, "molten-magma")
      add_fluid_filter(entity, "plasma")
      add_fluid_filter(entity, "biomass")
      add_fluid_filter(entity, "ammonia")
    end
  end
end
