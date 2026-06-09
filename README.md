# Better Oil Production

A Factorio mod that enhances oil extraction with improved pumpjack tiers and — when playing with Space Age — a complete space-based oil synthesis chain.

---

## Pumpjacks

Three new pumpjack variants replace the vanilla one at progressively higher tech tiers:

| Machine | Speed | Energy | Depletion | Tech Required |
|---|---|---|---|---|
| **Better Pumpjack** | 2× | 170kW | Normal | Better Pumpjack |
| **Better Pumpjack Mk2** | 4× | 420kW | Normal | Better Pumpjack Mk2 |
| **Eco-Friendly Pumpjack** | 0.5× | 55kW | 10× slower | Eco-Friendly Pumpjack |

The Eco pumpjack trades throughput for drastically reduced resource depletion — two Eco pumps match a vanilla pumpjack's output while depleting the field ten times slower (0.5× speed × 20% drain rate), keeping oil fields alive far longer.

---

## Hydraulic Fracturing

The **Fracking Station** boosts a depleted oil patch by injecting high-pressure steam. Place it directly adjacent (N/S/E/W) to any pumpjack.

- Requires a continuous steam supply (100/cycle)
- Slowly boosts the patch — up to 150 % of its original yield
- One station per pumpjack; the pumpjack must be actively working
- Pauses automatically at the cap and resumes when oil is drawn back down (state is circuit-readable)

**Research:** `Hydraulic Fracturing` — requires Advanced Oil Processing, the Better Pumpjack tech, and production science.

---

## Enhanced Oil Recovery

The **EOR Injector** is a late-game machine that continuously restores every crude-oil patch within a 10-tile radius by injecting light oil.

- Requires a continuous light-oil supply (100/s)
- Recovers patches up to 70 % of their original yield
- Effective crafting speed scales the recovery rate (speed modules / beacons apply)
- Best deployed on fields that have fallen below 50 % — the closer to depletion, the higher the net gain

**Research:** `Enhanced Oil Recovery` — requires Better Pumpjack Mk2 tech and Hydraulic Fracturing.

---

## Space Age: Oil from Asteroids

With the Space Age DLC installed, a new production chain lets you source crude oil entirely from space:

```
Carbonic Asteroid
       │  crush (30% bonus drop)
       ▼
Hydrocarbon Chunk
       │  Assembling Machine (crafting-with-fluid) + Water
       ▼
Synthetic Crude  ──► rocket back to planet
       │  Chemical Plant (heat only)
       ▼
  300× Crude Oil
```

Hydrocarbon chunks drop with 30 % probability when crushing carbonic asteroids. Synthetic crude is processed in any standard assembling machine (AM2+) using the `Space Hydrocarbon Synthesis` recipe (water comes from ice asteroids), then converted to crude oil in a chemical plant on the planet surface.

**Research:** `Space Oil Synthesis` — requires automation, logistic, chemical, and space science packs. Unlocks after Advanced Pumpjacks and the first rocket launch.

---

## Mod Compatibility

### Space Age
- All three pumpjacks are restricted to atmosphere-bearing planets (no space placement).
- Pumpjacks include heating energy for cold-planet survival (e.g. Aquilo).
- Better Pumpjack Mk2 technology requires space science pack (first rocket launch).
- Eco technology requires agricultural science pack (Gleba tier).

### Krastorio 2
- Fully compatible. No technology or recipe conflicts.

### Space Exploration
- Mk3 and Eco technologies use `se-rocket-science-pack` instead of space-tier packs.

---

## Dependencies

- **Required:** Factorio base `>= 2.0.2`
- **Optional:** Space Age `>= 2.0.2`
- **Optional:** Krastorio 2
- **Optional:** Space Exploration
- **Optional:** Better Energy Production `>= 0.5.3`

---

## Links

- [GitHub](https://github.com/errkyde/BetterOilProduction)
- [Factorio Mod Portal](https://mods.factorio.com/mod/Better-Oil-Production)
