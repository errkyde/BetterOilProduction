data:extend({
  {
    type = "item",
    name = "better-pumpjack-mk2",
    icon = "__BetterOilProduction__/graphics/icons/better-pumpjack-mk2.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "extraction-machine",
    order = "b[fluids]-b[pumpjack]-b[mk2]",
    place_result = "better-pumpjack-mk2",
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
  }
})

-- Space Age Items
if mods["space-age"] then
  data:extend({
    {
      type = "item",
      name = "oil_rich-asteroid-chunk",
      -- Reuse Space Age metallic chunk icon to avoid missing assets
      icon = "__space-age__/graphics/icons/metallic-asteroid-chunk.png",
      icon_size = 64,
      subgroup = "space-material",
      order = "e[oil-rich]-a[chunk]",
      stack_size = 100
    }
  })
end
