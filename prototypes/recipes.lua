data:extend({
  {
    type = "recipe",
    name = "better-pumpjack",
    enabled = false,
    energy_required = 7,
    ingredients = {
      {type = "item", name = "pumpjack", amount = 1},
      {type = "item", name = "steel-plate", amount = 20},
      {type = "item", name = "advanced-circuit", amount = 10}
    },
    results = {
      {type = "item", name = "better-pumpjack", amount = 1}
    },
    allow_as_intermediate = true,
  },
  {
    type = "recipe",
    name = "better-pumpjack-mk2",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "better-pumpjack",   amount = 1},
      {type = "item", name = "steel-plate",           amount = 40},
      {type = "item", name = "electric-engine-unit",  amount = 12},
      {type = "item", name = "processing-unit",       amount = 8},
      {type = "item", name = "concrete",              amount = 20}
    },
    results = {
      {type = "item", name = "better-pumpjack-mk2", amount = 1}
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
  }
})
