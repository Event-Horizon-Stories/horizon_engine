# Lesson 04: Missing Epochs

In lesson 3, the Horizon Engine learned that replay can branch when the source history is contradictory.

In lesson 4, it learns how to reason about history that is not contradictory, but missing.

Interactive companion: [`../livebooks/04_missing_epochs.livemd`](../livebooks/04_missing_epochs.livemd)

## What You'll Learn

- why missing history is different from empty history
- how to represent inferred events without pretending they were observed
- how later lessons can extend earlier code without replacing it

## The Story

At the end of lesson 3, the team had already learned that replay could branch into multiple timelines.

Then they found a different kind of failure.

The trace jumps from tick `1` to tick `4`.

Worse, the first event after the gap depends on something that should have happened at tick `3`.

Now the inquiry has to ask a new question:

- did nothing happen there?
- or was something erased?

## The Event Sourcing Concept

This lesson is about inferred events.

In event-sourced systems, not every useful record is a directly observed fact.
Sometimes the correct move is to append or project a visibly inferred placeholder so uncertainty stays explicit.

That is very different from silently hiding the gap behind a snapshot.

## What We're Building

We will build:

- a gap scanner
- an inference projector for missing epochs
- a lesson trace that can still be read by the earlier projections and replay tools

## The Code

This lesson lives in:

- [`lib/missing_epochs/event_store.ex`](./lib/missing_epochs/event_store.ex)
- [`lib/missing_epochs/universe_snapshot.ex`](./lib/missing_epochs/universe_snapshot.ex)
- [`lib/missing_epochs/cosmic_timeline.ex`](./lib/missing_epochs/cosmic_timeline.ex)
- [`lib/missing_epochs/structure_emergence.ex`](./lib/missing_epochs/structure_emergence.ex)
- [`lib/missing_epochs/causality_graph.ex`](./lib/missing_epochs/causality_graph.ex)
- [`lib/missing_epochs/anomaly_detector.ex`](./lib/missing_epochs/anomaly_detector.ex)
- [`lib/missing_epochs/replayer.ex`](./lib/missing_epochs/replayer.ex)
- [`lib/missing_epochs/contradiction_detector.ex`](./lib/missing_epochs/contradiction_detector.ex)
- [`lib/missing_epochs/gap_scanner.ex`](./lib/missing_epochs/gap_scanner.ex)
- [`lib/missing_epochs/inference_projector.ex`](./lib/missing_epochs/inference_projector.ex)
- [`test/missing_epochs_test.exs`](./test/missing_epochs_test.exs)

Core pieces:

```elixir
defmodule MissingEpochs.GapScanner do
  def project(events) do
    ticks = Enum.map(events, & &1.tick)

    ticks
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(fn [left, right] ->
      if right - left > 1 do
        [%{from_tick: left + 1, to_tick: right - 1}]
      else
        []
      end
    end)
  end
end
```

```elixir
defmodule MissingEpochs.InferenceProjector do
  def project(events) do
    inferred_events =
      events
      |> GapScanner.project()
      |> Enum.flat_map(&expand_gap(&1, events))

    (events ++ inferred_events)
    |> Enum.sort_by(fn event -> {event.tick, inferred_rank(event)} end)
    |> Enum.map(&normalize/1)
  end
end
```

## Trying It Out

```bash
cd 04_missing_epochs
mix test
```

Then inspect the gaps and inferred placeholders:

```bash
iex -S mix
```

```elixir
events = MissingEpochs.sample_trace()
MissingEpochs.GapScanner.project(events)
MissingEpochs.InferenceProjector.project(events)
```

## What the Tests Prove

The test in [`test/missing_epochs_test.exs`](./test/missing_epochs_test.exs) proves two things:

- the new gap layer can distinguish between plausible silence and likely erasure
- the earlier projections and replay layer still remain useful on the same trace

That matters because the reader can see uncertainty become part of the model instead of a reason to throw the model away.

## Why This Matters

Good event-sourced systems do not erase uncertainty just because uncertainty is inconvenient.

If history is missing, the model should say so directly.

## Event Sourcing Takeaway

Sometimes the right read model is not a confident answer.

Sometimes the right read model is an explicit statement that the history is incomplete, damaged, or only partially inferable.

## What Still Hurts

The team can now talk honestly about missing intervals.

But some surviving events point to causes that do not belong inside the missing interval at all.
They point to something from before the beginning.

## Next Lesson

In [`05_pre_origin_model`](../05_pre_origin_model/README.md), we will keep the full stack from chapter 4 and add pre-origin dependency handling that lets the engine reinterpret the beginning itself.

That is where the investigation turns from archaeology into something stranger.
