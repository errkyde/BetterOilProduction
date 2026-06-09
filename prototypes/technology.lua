data:extend({
    {
        type = "technology",
        name = "better-pumpjack",
        icon = "__Better-Oil-Production__/graphics/technology/better-pumpjack.png",
        icon_size = 256,
        prerequisites = {"advanced-oil-processing"},
        effects =
        {
            { type = "unlock-recipe", recipe = "better-pumpjack" }
        },
        unit =
        {
            count = 250,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
            },
            time = 30
        },
        order = "d-a"
    },
    {
        type = "technology",
        name = "better-pumpjack-mk2",
        icon = "__Better-Oil-Production__/graphics/technology/better-pumpjack-mk2.png",
        icon_size = 256,
        prerequisites = {"better-pumpjack"},
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
                {"production-science-pack", 1},
                {"utility-science-pack", 1},
            },
            time = 45
        },
        order = "d-b"
    },
    {
        type = "technology",
        name = "better-pumpjack-eco",
        icon = "__Better-Oil-Production__/graphics/technology/better-pumpjack-eco.png",
        icon_size = 256,
        prerequisites = {"better-pumpjack"},
        effects =
        {
            { type = "unlock-recipe", recipe = "better-pumpjack-eco" }
        },
        unit =
        {
            count = 350,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
            },
            time = 30
        },
        order = "d-c"
    }
})