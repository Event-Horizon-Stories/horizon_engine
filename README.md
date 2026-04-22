# horizon_engine

`horizon_engine` teaches event sourcing through **The Origin Inquiry**, an investigation into how the universe began.

A distant civilization discovers that background radiation behaves like corrupted telemetry. The working assumption becomes unbearable:

the universe did not merely happen.
it executed.

The Horizon Engine is built to ingest fragments of that trace and reconstruct what reality appears to have done.

Nothing is trusted as state.
Everything is treated as events.

## Interactive Companions

Livebook companions for the full series live in [`livebooks/`](./livebooks/README.md).

- [`livebooks/01_observation_log.livemd`](./livebooks/01_observation_log.livemd)
- [`livebooks/02_competing_projections.livemd`](./livebooks/02_competing_projections.livemd)
- [`livebooks/03_first_replay.livemd`](./livebooks/03_first_replay.livemd)
- [`livebooks/04_missing_epochs.livemd`](./livebooks/04_missing_epochs.livemd)
- [`livebooks/05_pre_origin_model.livemd`](./livebooks/05_pre_origin_model.livemd)

## The Journey

Each lesson is its own standalone Mix project, but the investigation and the event sourcing ideas advance together:

1. [`01_observation_log`](./01_observation_log/README.md)
   The first raw observations enter an append-only log, and the reader learns that history is the only durable truth.
2. [`02_competing_projections`](./02_competing_projections/README.md)
   Several projections read the same log and tell different stories about structure, causality, and anomalies.
3. [`03_first_replay`](./03_first_replay/README.md)
   The first replay from time zero produces multiple valid timelines, and the reader learns that replay cannot invent certainty.
4. [`04_missing_epochs`](./04_missing_epochs/README.md)
   Gaps appear in the trace, and the reader learns how inferred events preserve uncertainty instead of hiding it.
5. [`05_pre_origin_model`](./05_pre_origin_model/README.md)
   Dependencies from before the beginning emerge, and the reader learns how newly appended events can reinterpret old history.

## Final Inquiry Shape

By the end of the tutorial, the Horizon Engine looks roughly like this:

```text
raw observations
|- cosmic timeline
|- universe snapshot
|- structure emergence
|- causality graph
|- anomaly detector
|- replay candidates
|- inferred missing epochs
`- pre-origin continuation model
```

That shape is intentionally small. It is enough structure to teach the core event sourcing arc without turning the series into a giant cosmology simulator.

The repo root only holds the series guide. Each chapter owns its own code, dependencies, and tests.

## Beyond the Series

The five main chapters already cover the core event sourcing arc most readers need:

- append-only history
- projections
- replay
- contradictory histories
- inferred gaps
- late-arriving events that reinterpret the past

There are a few natural branches that could become bonus chapters or appendices later:

- **Persistent event stores**: moving from in-memory traces to durable logs once the inquiry needs longer-lived history.
- **Projection rebuild workflows**: rebuilding several read models after a new interpretation layer appears.
- **Operator decisions**: accepting, rejecting, or quarantining inferred and pre-origin events.
- **Competing engines**: letting rival reconstruction systems produce conflicting continuations from the same source trace.

Those are worth learning. They simply sit one layer past the story this series is trying to tell.

## Tooling

Each chapter is a small standalone Mix project.

If `mix` is not available in your shell, configure your asdf shims first rather than prefixing each command manually.

For the Livebook companions, install and run Livebook from the repo root:

```bash
mix escript.install hex livebook
livebook server livebooks
```

## Start Here

Begin with [`01_observation_log`](./01_observation_log/README.md).

That chapter introduces the central event sourcing idea:

```elixir
events = HorizonEngine.EventStore.append(events, :fluctuation_detected, %{sensor: "cmb-array"})
snapshot = HorizonEngine.UniverseSnapshot.project(events)
```

Before the inquiry can interpret the universe, it first needs a history it can trust.

Then run each lesson independently:

```bash
cd 01_observation_log && mix test
cd ../02_competing_projections && mix test
cd ../03_first_replay && mix test
cd ../04_missing_epochs && mix test
cd ../05_pre_origin_model && mix test
```
