# Lesson 01: The Observation Log

The Horizon Engine begins with one discipline:

do not store what the universe is.
store only what the universe appears to have done.

Interactive companion: [`../livebooks/01_observation_log.livemd`](../livebooks/01_observation_log.livemd)

## What You'll Learn

- why event sourcing starts with an append-only history
- how projections reconstruct state instead of persisting it directly
- why early read models should stay simple and explicit

## The Story

A distant civilization discovers that background radiation behaves less like noise and more like damaged telemetry.

The first Horizon Engine team has almost nothing: a corrupted archive, a few readable fragments, and a refusal to guess too early.

So they make one hard rule for the whole inquiry:

- observations go into the log
- explanations stay out of the log

That decision becomes the foundation every later lesson inherits.

## The Event Sourcing Concept

This lesson is about the basic event sourcing contract:

history is the durable truth surface.
state is a derived view of that history.

The stored records are raw events such as `fluctuation_detected`, `particle_emitted`, and `symmetry_broken`.

The useful view of the universe is reconstructed later by replaying those events into a projection.

## What We're Building

We will create:

- an append-only event store
- a timeline projection
- a reconstructed universe snapshot

The goal is not to explain the universe yet. The goal is to establish the discipline of storing history before meaning.

## The Code

This lesson lives in:

- [`lib/observation_log/event_store.ex`](./lib/observation_log/event_store.ex)
- [`lib/observation_log/cosmic_timeline.ex`](./lib/observation_log/cosmic_timeline.ex)
- [`lib/observation_log/universe_snapshot.ex`](./lib/observation_log/universe_snapshot.ex)
- [`test/observation_log_test.exs`](./test/observation_log_test.exs)

Core pieces:

```elixir
defmodule ObservationLog.EventStore do
  def append(events, type, attributes, opts \\ []) when is_list(events) and is_atom(type) do
    sequence = length(events)

    event = %{
      sequence: sequence,
      type: type,
      observed_at: Keyword.get(opts, :observed_at, sequence),
      attributes: Map.new(attributes)
    }

    events ++ [event]
  end
end
```

```elixir
defmodule ObservationLog.UniverseSnapshot do
  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: structure_possible?(events),
      last_observed_sequence: last_sequence(events)
    }
  end
end
```

## Trying It Out

```bash
cd 01_observation_log
mix test
```

Then explore it in `iex`:

```bash
iex -S mix
```

```elixir
events = ObservationLog.sample_trace()
ObservationLog.CosmicTimeline.project(events)
ObservationLog.UniverseSnapshot.project(events)
```

## What the Tests Prove

The test in [`test/observation_log_test.exs`](./test/observation_log_test.exs) proves three core ideas:

- events are appended in order and retained as raw facts
- a readable timeline can be projected from that history
- a current-state snapshot can be rebuilt from the same history without being stored separately

That matters because every later chapter depends on this rule staying true.

## Why This Matters

Event sourcing only becomes trustworthy when the log remains simpler than the interpretations built on top of it.

If the team discovers a better cosmology later, they do not need to rewrite the past. They only need a better projection.

## Event Sourcing Takeaway

The first event-sourcing rule is simple:

store history first.
derive state second.

If the stored record already contains interpretation, the system loses the ability to rethink the past honestly.

## What Still Hurts

The team can now store observations safely, but they can only ask one simple question:

what happened, in order?

That is not enough to run the inquiry. They still need projections that ask different questions of the same history.

## Next Lesson

In [`02_competing_projections`](../02_competing_projections/README.md), we will keep this event log and add multiple projections over it.

That is where the Horizon Engine stops being a recorder and starts becoming an interpreter.
