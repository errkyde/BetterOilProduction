require("prototypes.entities")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.technology")

-- Space Age Integration
if mods["space-age"] then
  require("prototypes.asteroid-chunk")
end