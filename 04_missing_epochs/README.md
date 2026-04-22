# Lesson 04: Missing Epochs

The replay and projection stack survives from lesson 3.
This chapter adds a way to model absence honestly.

The code is cumulative: nothing from the earlier lessons is removed. We add gap handling on top of the existing event-sourcing surface.

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

We are keeping the chapter 3 pieces:

- the event store
- the snapshot projection
- the timeline projection
- structure emergence
- the causality graph
- the anomaly detector
- replay
- contradiction detection

Then we add:

- a gap scanner
- an inference projector for missing epochs

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

The test in [`test/missing_epochs_test.exs`](./test/missing_epochs_test.exs) proves two cumulative properties:

- the older projections and replay layer still work on the new chapter 4 trace
- the new gap layer can distinguish between plausible silence and likely erasure

That matters because the series is not resetting the design. It is extending it.

## Why This Matters

Good event-sourced systems do not erase uncertainty just because uncertainty is inconvenient.

If history is missing, the model should say so directly.

## What Still Hurts

The team can now talk honestly about missing intervals.

But some surviving events point to causes that do not belong inside the missing interval at all.
They point to something from before the beginning.

## Next Lesson

In [`05_pre_origin_model`](../05_pre_origin_model/README.md), we will keep the full stack from chapter 4 and add pre-origin dependency handling that lets the engine reinterpret the beginning itself.

That is where the investigation turns from archaeology into something stranger.
