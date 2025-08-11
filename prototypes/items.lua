data:extend({
  {
    type = "item",
    name = "better-pumpjack-mk2",
    icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-mk2.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "extraction-machine",
    order = "b[fluids]-b[pumpjack]-b[mk2]",
    place_result = "better-pumpjack-mk2", -- muss exakt gleich mit entity-name sein
    stack_size = 20
  },
  {
    type = "item",
    name = "better-pumpjack-mk3",
    icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-mk3.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "extraction-machine",
    order = "b[fluids]-b[pumpjack]-c[mk3]",
    place_result = "better-pumpjack-mk3",
    stack_size = 20
  },
  {
    type = "item",
    name = "better-pumpjack-eco",
    icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-eco.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "extraction-machine",
    order = "b[fluids]-b[pumpjack]-d[eco]",
    place_result = "better-pumpjack-eco",
    stack_size = 20
  },
  {
    type = "item",
    name = "coal-refinery",
    icon = "__BetterOilProduction__/graphics/icons/coal-refinery.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "b[coal-refinery]",
    place_result = "coal-refinery",
    stack_size = 10
  }
})
