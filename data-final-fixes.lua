-- data-final-fixes: enforce the pumpjack tier speeds RELATIVE to the (possibly mod-altered)
-- vanilla pumpjack, so the relationships always hold no matter what other mods do to it
-- (e.g. Krastorio2 finite-oil doubles the vanilla pumpjack):
--   Better Pumpjack     = 2× vanilla
--   Better Pumpjack Mk2 = 2× Better        (= 4× vanilla)
--   Eco-Friendly        = 0.5× vanilla
-- This runs in the final data stage, so the vanilla pumpjack's mining_speed is already settled.

local vanilla = data.raw["mining-drill"]["pumpjack"]
if vanilla then
    local v = vanilla.mining_speed or 1.0

    local better = data.raw["mining-drill"]["better-pumpjack"]
    if better then better.mining_speed = v * 2 end

    local mk2 = data.raw["mining-drill"]["better-pumpjack-mk2"]
    if mk2 then
        -- "always double of Mk1" — base it on Better's final speed, not a separate constant.
        mk2.mining_speed = (better and better.mining_speed or v * 2) * 2
    end

    local eco = data.raw["mining-drill"]["better-pumpjack-eco"]
    if eco then eco.mining_speed = v * 0.5 end
end
