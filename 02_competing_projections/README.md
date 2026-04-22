# Lesson 02: Competing Projections

The log survives from lesson 1.
The questions get sharper.

This chapter is cumulative: the snapshot and timeline remain, and new projections are layered on top.

## What You'll Learn

- how one event stream can support several read models
- why projections are interpretations rather than truth
- how to keep the write side stable while the read side expands

## The Story

At the end of lesson 1, the team could safely store observations and replay one basic timeline.

That solved the trust problem, but not the inquiry.

Now the Horizon Engine team needs to answer several different questions:

- what happened, in order?
- when does structure begin to emerge?
- what seems to cause what?
- which events already look suspicious?

Each question becomes a projection over the same log.

## The Event Sourcing Concept

This lesson is about projection fan-out.

Event sourcing is not useful because it gives you one perfect state view.
It is useful because one durable event history can support many read models with different purposes.

The write model stays narrow.
The read model grows.

## What We're Building

We are keeping the chapter 1 pieces:

- the append-only event store
- the reconstructed universe snapshot
- the timeline projection

Then we add:

- a structure emergence projection
- a causality graph
- an anomaly detector

## The Code

This lesson lives in:

- [`lib/competing_projections/event_store.ex`](./lib/competing_projections/event_store.ex)
- [`lib/competing_projections/universe_snapshot.ex`](./lib/competing_projections/universe_snapshot.ex)
- [`lib/competing_projections/cosmic_timeline.ex`](./lib/competing_projections/cosmic_timeline.ex)
- [`lib/competing_projections/structure_emergence.ex`](./lib/competing_projections/structure_emergence.ex)
- [`lib/competing_projections/causality_graph.ex`](./lib/competing_projections/causality_graph.ex)
- [`lib/competing_projections/anomaly_detector.ex`](./lib/competing_projections/anomaly_detector.ex)
- [`test/competing_projections_test.exs`](./test/competing_projections_test.exs)

## Trying It Out

```bash
cd 02_competing_projections
mix test
```

Then inspect the same trace through several lenses:

```bash
iex -S mix
```

```elixir
events = CompetingProjections.sample_trace()
CompetingProjections.UniverseSnapshot.project(events)
CompetingProjections.StructureEmergence.project(events)
CompetingProjections.AnomalyDetector.project(events)
```

## What the Tests Prove

The test in [`test/competing_projections_test.exs`](./test/competing_projections_test.exs) proves that one event stream can support:

- a snapshot
- a chronology
- a structure model
- a dependency graph
- an anomaly view

That matters because the event log stays stable while meaning becomes plural.

## Why This Matters

This is the chapter where event sourcing starts to feel different from CRUD.

The log is not just feeding one current-state table.
It is feeding several competing explanations of the same universe.

## What Still Hurts

All of these projections still assume the recovered event order is trustworthy enough to replay cleanly.

That assumption is about to fail.

## Next Lesson

In [`03_first_replay`](../03_first_replay/README.md), we will keep these projections and add replay logic that branches when the source history is ambiguous.

That is where the inquiry stops being neat.
