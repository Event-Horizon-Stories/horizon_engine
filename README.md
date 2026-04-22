# horizon_engine

`horizon_engine` teaches event sourcing through **The Origin Inquiry**, an investigation into how the universe began.

A distant civilization discovers that background radiation behaves like corrupted telemetry. The working assumption becomes unbearable:

the universe did not merely happen.
it executed.

The Horizon Engine is built to ingest fragments of that trace and reconstruct what reality appears to have done.

Nothing is trusted as state.
Everything is treated as events.

Like `jido_class`, this is meant to read as one continuous journey.
The same investigation advances one pressure point at a time, and each chapter begins with whatever the previous chapter failed to explain.

## Interactive Companions

Livebook companions for the full series live in [`livebooks/`](./livebooks/README.md).

- [`livebooks/01_observation_log.livemd`](./livebooks/01_observation_log.livemd)
- [`livebooks/02_competing_projections.livemd`](./livebooks/02_competing_projections.livemd)
- [`livebooks/03_first_replay.livemd`](./livebooks/03_first_replay.livemd)
- [`livebooks/04_missing_epochs.livemd`](./livebooks/04_missing_epochs.livemd)
- [`livebooks/05_pre_origin_model.livemd`](./livebooks/05_pre_origin_model.livemd)

## The Journey

Each lesson is its own standalone Mix project. The concepts advance with the plot:

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

## Continuity

The chapters are not isolated examples.

They follow one uninterrupted escalation:

- first the team learns to keep raw observations without trusting snapshots
- then they build projections to ask richer questions of the same history
- then replay reveals contradictions in the source
- then gaps in the source become part of the model
- then the beginning itself stops behaving like a beginning

The continuity matters because event sourcing is not just a storage pattern here. It is the storytelling device.

## Core Premise

The system does not store what the universe is.
Only what it appears to have done.

That event-sourcing mental model maps directly onto the story:

- events are observations
- projections are interpretations
- replay is discovery
- contradictions are distributed truth problems
- missing events are gaps in recoverable history

## Repo Shape

The repo root is only the guide. Each lesson owns its own code, tests, and README so readers can move chapter by chapter without carrying framework state from one directory to the next.

## Start Here

Begin with [`01_observation_log`](./01_observation_log/README.md).

Then run each lesson independently:

```bash
cd 01_observation_log && mix test
cd ../02_competing_projections && mix test
cd ../03_first_replay && mix test
cd ../04_missing_epochs && mix test
cd ../05_pre_origin_model && mix test
```
