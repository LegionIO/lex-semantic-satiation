# lex-semantic-satiation

Semantic satiation modeling for LegionIO cognitive agents. Tracks fluency decay from repeated exposure and recovery during rest.

## What It Does

`lex-semantic-satiation` models the cognitive phenomenon where repeatedly processing the same concept reduces its perceived fluency and meaningfulness. Each registered concept carries a fluency score (starts at 1.0) that decreases with each exposure and recovers over rest.

- **Exposure**: each call to `expose` decrements fluency by 0.08; exposure count increments each time
- **Recovery**: bulk rest cycle increments all fluencies by 0.03 per call
- **Satiation**: concepts with fluency < 0.3 are flagged as satiated
- **Novelty**: computed from exposure count (100% novel = 0 exposures; 0% novel = 50+ exposures)
- **Pruning**: concepts at fluency <= 0.05 can be pruned to make room for new ones

## Usage

```ruby
require 'legion/extensions/semantic_satiation'

client = Legion::Extensions::SemanticSatiation::Client.new

# Register a concept
result = client.register(label: 'recursion', domain: :programming)
id = result[:concept_id]

# Expose it repeatedly
5.times { client.expose(concept_id: id) }
# => { fluency: 0.6, exposure_count: 5, satiated: false }

# Check what is satiated
client.satiation_status
# => { satiated_count: 0, total: 1, satiated: [] }

# Run a rest/recovery cycle
client.recover
# => { success: true, recovered_count: 1 }

# See novelty distribution
client.novelty_report
# => { novel: 1, familiar: 0, common: 0, repeated: 0, overexposed: 0 }

# Domain-level satiation
client.domain_satiation(domain: :programming)
# => { domain: :programming, mean_fluency: 0.65 }

# Remove nearly-faded concepts
client.prune_saturated
# => { success: true, pruned_count: 0 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
