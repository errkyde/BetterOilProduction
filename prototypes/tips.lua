data:extend({
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
    {
        type = "tips-and-tricks-item",
        name = "bop-fracking",
        category = "bop-oil-production",
        order = "b",
        trigger = {
            type = "build-entity",
            entity = "bop-fracking-station",
            count = 1,
        },
    },
    {
        type = "tips-and-tricks-item",
        name = "bop-eor",
        category = "bop-oil-production",
        order = "c",
        trigger = {
            type = "build-entity",
            entity = "bop-eor-injector",
            count = 1,
        },
    },
})
