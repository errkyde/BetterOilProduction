require("prototypes.entities")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.technology")
require("prototypes.tips")
-- Fracking Station + EOR Injector are disabled for now (kept in code). Flip the flag in
-- feature-flags.lua to load their prototypes again.
if require("feature-flags").fracking_eor then
    require("prototypes.fracking")
end