# Lesson 05: The Pre-Origin Model

The entire code path from lesson 4 survives into the finale.
This chapter adds one last layer instead of replacing anything.

The series now has a fully cumulative event-sourcing ladder: projections, replay, gap inference, and finally pre-origin completion.

## What You'll Learn

- how newly appended events can reinterpret old history without mutating it
- why event sourcing allows meaning to change while records remain immutable
- how a cumulative tutorial can preserve earlier code while extending its model

## The Story

At the end of lesson 4, the team could finally name missing epochs honestly.

That should have stabilized the inquiry.

Instead, some surviving events start depending on a cause that does not belong in the gap at all.
It belongs before the beginning.

An analyst proposes the Pre-Origin Model:

tick `0` is not the start of reality.
It is only the first surviving fragment of the log.

Then the Horizon Engine does something worse than fail.
It appends a new event that resolves the missing pre-origin dependency.

## The Event Sourcing Concept

This lesson is about late-arriving meaning.

In event sourcing, new events do not rewrite old ones.
They extend the history.

That means the interpretation of the past can change even when the past records remain immutable.

## What We're Building

We are keeping the chapter 4 pieces:

- the event store
- the snapshot projection
- the timeline projection
- structure emergence
- the causality graph
- the anomaly detector
- replay
- contradiction detection
- the gap scanner
- the inference projector

Then we add:

- a dependency analyzer for unresolved pre-origin references
- a completion step that appends a new anchor event
- a projection that reinterprets the beginning as continuation

## The Code

This lesson lives in:

- [`lib/pre_origin_model/event_store.ex`](./lib/pre_origin_model/event_store.ex)
- [`lib/pre_origin_model/universe_snapshot.ex`](./lib/pre_origin_model/universe_snapshot.ex)
- [`lib/pre_origin_model/cosmic_timeline.ex`](./lib/pre_origin_model/cosmic_timeline.ex)
- [`lib/pre_origin_model/structure_emergence.ex`](./lib/pre_origin_model/structure_emergence.ex)
- [`lib/pre_origin_model/causality_graph.ex`](./lib/pre_origin_model/causality_graph.ex)
- [`lib/pre_origin_model/anomaly_detector.ex`](./lib/pre_origin_model/anomaly_detector.ex)
- [`lib/pre_origin_model/replayer.ex`](./lib/pre_origin_model/replayer.ex)
- [`lib/pre_origin_model/contradiction_detector.ex`](./lib/pre_origin_model/contradiction_detector.ex)
- [`lib/pre_origin_model/gap_scanner.ex`](./lib/pre_origin_model/gap_scanner.ex)
- [`lib/pre_origin_model/inference_projector.ex`](./lib/pre_origin_model/inference_projector.ex)
- [`lib/pre_origin_model/dependency_analyzer.ex`](./lib/pre_origin_model/dependency_analyzer.ex)
- [`lib/pre_origin_model/horizon_completer.ex`](./lib/pre_origin_model/horizon_completer.ex)
- [`lib/pre_origin_model/pre_origin_projection.ex`](./lib/pre_origin_model/pre_origin_projection.ex)
- [`test/pre_origin_model_test.exs`](./test/pre_origin_model_test.exs)

## Trying It Out

```bash
cd 05_pre_origin_model
mix test
```

Then inspect the completed origin model:

```bash
iex -S mix
```

```elixir
events = PreOriginModel.sample_trace()
completed = PreOriginModel.HorizonCompleter.complete(events)
PreOriginModel.PreOriginProjection.project(completed)
```

## What the Tests Prove

The test in [`test/pre_origin_model_test.exs`](./test/pre_origin_model_test.exs) proves the full cumulative story:

- the gap layer from lesson 4 still works
- the older projections still work on the extended trace
- the engine can append a new pre-origin anchor event
- the meaning of the beginning changes without rewriting any earlier event

That is the final event-sourcing move in the series.

## Why This Matters

The log remains the only truth surface, but the meaning of the past is still alive.

That is why event sourcing fits this story so well:
history stays immutable while understanding keeps changing.

## What Still Hurts

The implementation works, but the world is not resolved.

The open questions are the point now:

- are the inferred anchors discoveries or inventions?
- why do present-day completions fit the ancient trace so perfectly?
- is the Horizon Engine reconstructing the universe or helping complete it?

## Where The Series Could Go Next

If the series continues, the next chapter should probably explore rival engines, contested completions, or operator workflows for accepting and rejecting inferred pre-origin events.

That would keep the code cumulative while pushing the reality problem even further.
