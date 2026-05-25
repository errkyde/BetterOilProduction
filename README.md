# Better Oil Production

A Factorio mod that enhances oil extraction with improved pumpjack tiers and — when playing with Space Age — a complete space-based oil synthesis chain.

---

## Pumpjacks

Three new pumpjack variants replace the vanilla one at progressively higher tech tiers:

| Machine | Speed | Depletion | Tech Required |
|---|---|---|---|
| **Better Pumpjack Mk2** | 2× | Normal | Advanced Pumpjacks |
| **Better Pumpjack Mk3** | 4× | Normal | Advanced Pumpjacks Mk3 |
| **Eco-Friendly Pumpjack** | 1× | Minimal | Eco Pumpjacks |

The Eco pumpjack trades raw throughput for drastically reduced resource depletion — useful for keeping oil fields alive indefinitely.

---

## Space Age: Oil from Asteroids

With the Space Age DLC installed, a new production chain lets you source crude oil entirely from space:

```
Carbonic Asteroid
       │  crush (30% bonus drop)
       ▼
Hydrocarbon Chunk
       │  Hydrocarbon Synthesizer + Water
       ▼
Synthetic Crude  ──► rocket back to planet
       │  Chemical Plant (heat only)
       ▼
  500× Crude Oil
```

**Hydrocarbon Synthesizer** — a space-rated assembling machine built on your platform. Feeds on hydrocarbon chunks and water. Supports productivity and speed modules.

**Research:** `Space Oil Synthesis` — requires automation, logistic, chemical, space, and metallurgic science packs. Unlocks after Advanced Pumpjacks and Space Science Pack.

---

## Mod Compatibility

### Space Age
- All three pumpjacks are restricted to atmosphere-bearing planets (no space placement).
- Pumpjacks include heating energy for cold-planet survival (e.g. Aquilo).
- Mk3 technology requires metallurgic science pack (Vulcanus tier).
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
