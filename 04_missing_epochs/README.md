# Lesson 04: Missing Epochs

The Horizon Engine has already survived its first contradiction.

That should have made the inquiry harder. Instead, it revealed a worse problem.

Contradictions are at least visible. Gaps are harder. A contradiction tells you two things cannot both be true. A missing epoch leaves you unsure whether anything happened at all, or whether the silence itself is evidence.

This lesson teaches the system how to treat absence as part of the model instead of a blank space the reader is expected to ignore.

Interactive companion: [`../livebooks/04_missing_epochs.livemd`](../livebooks/04_missing_epochs.livemd)

## What You'll Learn

By the end of this lesson, you should understand:

- why missing history is different from empty history
- how to represent inferred events without pretending they were observed
- how later lessons can extend earlier code without replacing it

## The Story

The recovered trace does not merely contradict itself.

It also disappears.

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

- [`lib/horizon_engine.ex`](./lib/horizon_engine.ex)
- [`lib/event_store.ex`](./lib/event_store.ex)
- [`lib/universe_snapshot.ex`](./lib/universe_snapshot.ex)
- [`lib/cosmic_timeline.ex`](./lib/cosmic_timeline.ex)
- [`lib/structure_emergence.ex`](./lib/structure_emergence.ex)
- [`lib/causality_graph.ex`](./lib/causality_graph.ex)
- [`lib/anomaly_detector.ex`](./lib/anomaly_detector.ex)
- [`lib/replayer.ex`](./lib/replayer.ex)
- [`lib/contradiction_detector.ex`](./lib/contradiction_detector.ex)
- [`lib/gap_scanner.ex`](./lib/gap_scanner.ex)
- [`lib/inference_projector.ex`](./lib/inference_projector.ex)
- [`test/missing_epochs_test.exs`](./test/missing_epochs_test.exs)

Core pieces:

```elixir
defmodule HorizonEngine.GapScanner do
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
defmodule HorizonEngine.InferenceProjector do
  def project(events) do
    inferred_events =
      events
      |> GapScanner.project()
      |> Enum.with_index(length(events))
      |> Enum.flat_map(&expand_gap(&1, events))

    (events ++ inferred_events)
    |> Enum.sort_by(fn event -> {event.tick, inferred_rank(event), Map.get(event, :sequence, -1)} end)
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
events = HorizonEngine.sample_trace()
inferred_events = HorizonEngine.InferenceProjector.project(events)

HorizonEngine.GapScanner.project(events)
HorizonEngine.CosmicTimeline.project(inferred_events)
HorizonEngine.Replayer.replay(inferred_events)
```

## What the Tests Prove

The test in [`test/missing_epochs_test.exs`](./test/missing_epochs_test.exs) proves two things:

- the new gap layer can distinguish between plausible silence and likely erasure
- the earlier projections and replay layer still remain useful on the inferred timeline

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
