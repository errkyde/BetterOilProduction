require("prototypes.entities")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.technology")

-- Optional Space Age check (wenn du später im Script was für Space Age machen willst)
if mods["space-exploration"] then
  require("data-updates")
end