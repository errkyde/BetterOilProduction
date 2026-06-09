-- Feature flags for Better Oil Production.
--
-- These gate optional features at load time WITHOUT deleting their implementation, so a
-- feature can be re-enabled later by flipping its flag back to true. Required from the data
-- stage (data.lua / data-updates.lua / prototypes/tips.lua); all data-stage files share one
-- Lua state, so the returned table is cached across them.
return {
    -- Fracking Station + EOR Injector and everything that depends on them: their entities,
    -- items, recipes, recipe categories, technologies, Polymer Slurry fluid, tips-and-tricks
    -- entries, and the Krastorio2 / Space Age recipe and tech tie-ins. The runtime logic in
    -- control.lua stays loaded but is inert while this is false (the prototypes never exist,
    -- so nothing is ever built or processed).
    fracking_eor = false,
}
