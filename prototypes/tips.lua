local tips = {
    {
        type = "tips-and-tricks-item-category",
        name = "bop-oil-production",
        order = "z[bop-oil-production]",
    },
    {
        type = "tips-and-tricks-item",
        name = "bop-eco-pumpjack",
        category = "bop-oil-production",
        order = "a",
        trigger = {
            type = "build-entity",
            entity = "better-pumpjack-eco",
            count = 1,
        },
    },
}

-- The Fracking / EOR tips trigger on building those machines, which only exist when the
-- feature is enabled. Including them while the entities are absent would be a broken reference.
if require("feature-flags").fracking_eor then
    tips[#tips + 1] = {
        type = "tips-and-tricks-item",
        name = "bop-fracking",
        category = "bop-oil-production",
        order = "b",
        trigger = {
            type = "build-entity",
            entity = "bop-fracking-station",
            count = 1,
        },
    }
    tips[#tips + 1] = {
        type = "tips-and-tricks-item",
        name = "bop-eor",
        category = "bop-oil-production",
        order = "c",
        trigger = {
            type = "build-entity",
            entity = "bop-eor-injector",
            count = 1,
        },
    }
end

data:extend(tips)
