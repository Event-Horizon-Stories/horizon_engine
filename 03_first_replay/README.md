# Lesson 03: The First Replay

In lesson 2, the Horizon Engine learned how to project several interpretations from the same history.

In lesson 3, it learns that replay does not guarantee certainty.

Interactive companion: [`../livebooks/03_first_replay.livemd`](../livebooks/03_first_replay.livemd)

## What You'll Learn

- how replay exposes uncertainty already present in the log
- why contradictory events can produce multiple valid timelines
- how to add replay logic without discarding earlier projections

## The Story

At the end of lesson 2, the team had several useful projections and a growing confidence that the trace could support real cosmology work.

Then they replayed the earliest readable slice of the origin log.

At the same recovered moment, the trace claims two incompatible things:

- the universe expanded
- the universe collapsed

The contradiction is not introduced by the projection.
It is already in the source.

## The Event Sourcing Concept

This lesson is about replay as discovery rather than certainty.

Event sourcing often gets summarized as "just replay the events."
That is incomplete.

Replay can only expose what the event history can support.
If the source is ambiguous, replay becomes ambiguous too.

## What We're Building

We will build:

- a replay engine that can branch into multiple candidate timelines
- a contradiction detector for mutually exclusive events at the same tick
- a lesson trace that still supports the earlier projections

## The Code

This lesson lives in:

- [`lib/first_replay/event_store.ex`](./lib/first_replay/event_store.ex)
- [`lib/first_replay/universe_snapshot.ex`](./lib/first_replay/universe_snapshot.ex)
- [`lib/first_replay/cosmic_timeline.ex`](./lib/first_replay/cosmic_timeline.ex)
- [`lib/first_replay/structure_emergence.ex`](./lib/first_replay/structure_emergence.ex)
- [`lib/first_replay/causality_graph.ex`](./lib/first_replay/causality_graph.ex)
- [`lib/first_replay/anomaly_detector.ex`](./lib/first_replay/anomaly_detector.ex)
- [`lib/first_replay/replayer.ex`](./lib/first_replay/replayer.ex)
- [`lib/first_replay/contradiction_detector.ex`](./lib/first_replay/contradiction_detector.ex)
- [`test/first_replay_test.exs`](./test/first_replay_test.exs)

Core pieces:

```elixir
defmodule FirstReplay.Replayer do
  def replay(events) do
    grouped = Enum.group_by(events, & &1.tick)
    ticks = grouped |> Map.keys() |> Enum.sort()

    Enum.reduce(ticks, [[]], fn tick, candidate_timelines ->
      grouped
      |> Map.fetch!(tick)
      |> expand_tick(candidate_timelines)
    end)
    |> Enum.map(&Enum.map(&1, fn event -> %{tick: event.tick, type: event.type} end))
  end
end
```

```elixir
defmodule FirstReplay.ContradictionDetector do
  def project(events) do
    events
    |> Enum.group_by(& &1.tick)
    |> Enum.flat_map(fn {tick, events_at_tick} ->
      types = events_at_tick |> Enum.map(& &1.type) |> Enum.sort()

      case types do
        [:collapse_measured, :expansion_measured] ->
          [%{tick: tick, conflicting_types: types}]

        _ ->
          []
      end
    end)
  end
end
```

## Trying It Out

```bash
cd 03_first_replay
mix test
```

Then inspect the replay candidates:

```bash
iex -S mix
```

```elixir
events = FirstReplay.sample_trace()
FirstReplay.Replayer.replay(events)
FirstReplay.ContradictionDetector.project(events)
```

## What the Tests Prove

The test in [`test/first_replay_test.exs`](./test/first_replay_test.exs) proves two things at once:

- replay can legitimately produce more than one candidate history when the source contains contradictions
- the earlier projections still remain useful even after replay becomes ambiguous

That matters because replay is not replacing the earlier lesson. It is deepening it.

## Why This Matters

Replay is one of the most powerful ideas in event sourcing, but it is not magic.

It does not manufacture certainty.
It only reveals what the log can honestly sustain.

## Event Sourcing Takeaway

Replay is not a promise that the past will become clean.

Replay is a way to ask the log, as honestly as possible, what histories it can still support.

## What Still Hurts

Contradictions are bad enough, but the next failure mode is worse:

sometimes history is not contradictory.
sometimes history is missing.

## Next Lesson

In [`04_missing_epochs`](../04_missing_epochs/README.md), we will keep the replay and projection stack intact and add explicit handling for gaps in the trace.

That is where absence becomes part of the model.
