# Lesson 03: The First Replay

The projections survive from lesson 2.
Now replay itself becomes unstable.

This chapter is cumulative: the snapshot, timeline, structure view, causality graph, and anomaly detector are still present before the replay layer is added.

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

We are keeping the chapter 2 pieces:

- the event store
- the snapshot projection
- the timeline projection
- structure emergence
- the causality graph
- the anomaly detector

Then we add:

- a replay engine that can branch into multiple candidate timelines
- a contradiction detector for mutually exclusive events at the same tick

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

- the older projections still work on the expanded chapter 3 event stream
- replay can legitimately produce more than one candidate history when the source contains contradictions

That matters because the code is now cumulative in the same way the story is cumulative.

## Why This Matters

Replay is one of the most powerful ideas in event sourcing, but it is not magic.

It does not manufacture certainty.
It only reveals what the log can honestly sustain.

## What Still Hurts

Contradictions are bad enough, but the next failure mode is worse:

sometimes history is not contradictory.
sometimes history is missing.

## Next Lesson

In [`04_missing_epochs`](../04_missing_epochs/README.md), we will keep the replay and projection stack intact and add explicit handling for gaps in the trace.

That is where absence becomes part of the model.
