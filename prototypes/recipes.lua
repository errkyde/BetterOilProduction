data:extend({
  {
    type = "recipe",
    name = "better-pumpjack-mk2",
    enabled = false,
    energy_required = 7,
    ingredients = {
      {type = "item", name = "pumpjack", amount = 1},
      {type = "item", name = "steel-plate", amount = 20},
      {type = "item", name = "advanced-circuit", amount = 10}
    },
    results = {
      {type = "item", name = "better-pumpjack-mk2", amount = 1}
    },
    allow_as_intermediate = true,
  },
  {
    type = "recipe",
    name = "better-pumpjack-mk3",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "better-pumpjack-mk2", amount = 1},
      {type = "item", name = "speed-module", amount = 2},
      {type = "item", name = "productivity-module", amount = 1},
      {type = "item", name = "processing-unit", amount = 20}
    },
    results = {
      {type = "item", name = "better-pumpjack-mk3", amount = 1}
    },
    allow_as_intermediate = true,
  },
  {
    type = "recipe",
    name = "better-pumpjack-eco",
    enabled = false,
    energy_required = 5,
    ingredients = {
      {type = "item", name = "pumpjack", amount = 1},
      {type = "item", name = "efficiency-module", amount = 3},
      {type = "item", name = "electric-engine-unit", amount = 5}
    },
    results = {
      {type = "item", name = "better-pumpjack-eco", amount = 1}
    },
    allow_as_intermediate = true,
  },
})

-- Space Age Recipes
if mods["space-age"] then
  data:extend({
    {
      type = "recipe",
      name = "asteroid-oil-processing",
      category = "oil-processing",
      enabled = false,
      energy_required = 5,
      ingredients = {
        {type = "item", name = "oil_rich-asteroid-chunk", amount = 1},
        {type = "fluid", name = "steam", amount = 50}
      },
      results = {
        {type = "fluid", name = "crude-oil", amount = 500}
      },
      icon = "__BetterOilProduction__/graphics/icons/asteroid-oil-processing.png",
      icon_size = 64,
      subgroup = "fluid-recipes",
      order = "a[oil-processing]-d[asteroid-oil]"
    }
  })
end