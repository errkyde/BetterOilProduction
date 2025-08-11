data:extend({
    {
        type = "technology",
        name = "advanced-pumpjacks",
        icon = "__BetterOilProduction__/graphics/technology/advanced-pumpjacks-mk2.png",
        icon_size = 256,
        prerequisites = {"advanced-oil-processing"},
        effects =
        {
            { type = "unlock-recipe", recipe = "better-pumpjack-mk2" }
        },
        unit =
        {
            count = 500,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1}
            },
            time = 30
        },
        order = "d-a"
    },
    {
        type = "technology",
        name = "advanced-pumpjacks-mk3",
        icon = "__BetterOilProduction__/graphics/technology/advanced-pumpjacks-mk3.png",
        icon_size = 256,
        prerequisites = {"advanced-pumpjacks"},
        effects =
        {
            { type = "unlock-recipe", recipe = "better-pumpjack-mk3" }
        },
        unit =
        {
            count = 1000,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 2},
                {"utility-science-pack", 1},
            },
            time = 60
        },
        order = "d-b"
    },
    {
        type = "technology",
        name = "eco-pumpjacks",
        icon = "__BetterOilProduction__/graphics/technology/eco-pumpjacks.png",
        icon_size = 256,
        prerequisites = {"advanced-oil-processing", "electric-engine"},
        effects =
        {
            { type = "unlock-recipe", recipe = "better-pumpjack-eco" }
        },
        unit =
        {
            count = 500,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 45
        },
        order = "d-c"
    },
})

-- Space Age Technologies
if mods["space-age"] then
  data:extend({
    {
      type = "technology",
      name = "asteroid-oil-processing",
      icon = "__BetterOilProduction__/graphics/technology/asteroid-oil-processing.png",
      icon_size = 256,
      prerequisites = {"advanced-oil-processing", "space-science-pack"},
      effects = {
        {
          type = "unlock-recipe",
          recipe = "asteroid-oil-processing"
        }
      },
      unit = {
        count = 1000,
        ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"space-science-pack", 1}
        },
        time = 30
      },
      order = "d-d"
    }
  })
end
