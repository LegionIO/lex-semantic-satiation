# lex-semantic-satiation

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-semantic-satiation`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::SemanticSatiation`

## Purpose

Models semantic satiation — the cognitive phenomenon where repeated exposure to a concept reduces its perceived fluency and meaningfulness. Each registered concept tracks a fluency score that decreases with each exposure and recovers during rest. Complements `lex-semantic-priming` (which tracks activation) — semantic satiation tracks overexposure fatigue, not activation strength.

## Gem Info

- **Gem name**: `lex-semantic-satiation`
- **License**: MIT
- **Ruby**: >= 3.4
- **No runtime dependencies** beyond the Legion framework

## File Structure

```
lib/legion/extensions/semantic_satiation/
  version.rb                          # VERSION = '0.1.0'
  helpers/
    constants.rb                      # limits, satiation rates, fluency labels, novelty labels
    concept.rb                        # Concept class — tracks fluency and exposure count
    satiation_engine.rb               # SatiationEngine class — concept store with bulk operations
  runners/
    semantic_satiation.rb             # Runners::SemanticSatiation module — all public runner methods
  client.rb                           # Client class including Runners::SemanticSatiation
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `MAX_CONCEPTS` | 300 | Maximum tracked concepts |
| `SATIATION_RATE` | 0.08 | Fluency decrease per `expose!` call |
| `RECOVERY_RATE` | 0.03 | Fluency increase per `recover!` call |
| `SATIATION_THRESHOLD` | 0.7 | Exposure count threshold above which concept is considered satiated |
| `DEFAULT_FLUENCY` | 1.0 | Starting fluency for new concepts |
| `FLUENCY_LABELS` | hash | Named tiers: fresh/normal/reduced/low/minimal based on fluency ranges |
| `NOVELTY_LABELS` | hash | Named tiers: novel/familiar/common/repeated/overexposed based on exposure count |

## Helpers

### `Helpers::Concept`

Named concept with fluency decay on exposure and recovery over rest.

- `initialize(id:, label:, domain: :general)` — fluency = DEFAULT_FLUENCY, exposure_count = 0
- `expose!` — decrements fluency by SATIATION_RATE; increments exposure_count; floors at 0.0
- `recover!` — increments fluency by RECOVERY_RATE; caps at DEFAULT_FLUENCY (1.0)
- `satiated?` — fluency < 0.3
- `fluency_label` — returns label from FLUENCY_LABELS based on current fluency
- `novelty` — `1 - [exposure_count / 50.0, 1.0].min` (linear decay to 0 at 50 exposures)
- `novelty_label` — returns label from NOVELTY_LABELS based on exposure_count

### `Helpers::SatiationEngine`

Store of Concept objects with bulk operations.

- `initialize` — empty concepts hash, keyed by concept id
- `register_concept(label:, domain: :general)` — creates concept; returns existing if label already registered; returns nil if at MAX_CONCEPTS
- `expose_concept(concept_id)` — calls `concept.expose!`; returns nil if not found
- `expose_by_label(label)` — finds concept by label, calls `expose!`
- `recover_all` — calls `recover!` on all concepts (bulk rest cycle)
- `satiated_concepts` — all concepts with `satiated? == true`
- `most_exposed` — sorted by exposure_count descending
- `freshest` — sorted by fluency descending
- `domain_satiation(domain)` — mean fluency across concepts in the given domain
- `novelty_report` — distribution of concepts across novelty label tiers
- `prune_saturated` — removes concepts with fluency <= 0.05

## Runners

All runners are in `Runners::SemanticSatiation`. The `Client` includes this module and owns a `SatiationEngine` instance.

| Runner | Parameters | Returns |
|---|---|---|
| `expose` | `concept_id:` | `{ success:, concept_id:, fluency:, exposure_count:, satiated: }` |
| `register` | `label:, domain: :general` | `{ success:, concept_id:, label:, fluency: }` |
| `expose_by_id` | `concept_id:` | Same as `expose` |
| `recover` | (none) | `{ success:, recovered_count: }` — calls `recover_all` |
| `satiation_status` | (none) | `{ success:, satiated_count:, total:, satiated: [...] }` |
| `domain_satiation` | `domain:` | `{ success:, domain:, mean_fluency: }` |
| `most_exposed` | `limit: 10` | `{ success:, concepts:, count: }` |
| `freshest_concepts` | `limit: 10` | `{ success:, concepts:, count: }` |
| `novelty_report` | (none) | Distribution hash from `SatiationEngine#novelty_report` |
| `prune_saturated` | (none) | `{ success:, pruned_count: }` |

## Integration Points

- **lex-semantic-priming**: priming tracks activation state; satiation tracks overexposure fatigue; they are complementary — a concept can be highly primed but also satiated
- **lex-semantic-memory**: semantic memory stores concept definitions; satiation can be applied to those same concept names to model processing fatigue
- **lex-tick / lex-cortex**: `recover` (bulk rest) can be wired as a tick phase handler to model passive fluency recovery between cycles
- **lex-dream**: the dream cycle's association walking may benefit from avoiding satiated concepts as seed nodes

## Development Notes

- Concepts are keyed by auto-generated UUID id, not by label — allows multiple concepts with similar labels in different domains
- `expose_by_label` performs a linear scan by label string; for performance with MAX_CONCEPTS=300, this is acceptable
- `novelty` uses a cap at 50 exposures — beyond 50, novelty is always 0.0
- `prune_saturated` removes concepts at fluency <= 0.05, not 0.0 — allows for concepts to be pruned before completely fading, making room in the 300-concept store
- `recover_all` is a uniform recovery pass; there is no per-concept recovery rate differentiation in the current implementation
