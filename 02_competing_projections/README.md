# Lesson 02: Competing Projections

The Horizon Engine can already store raw observations without corrupting them with interpretation.

That is necessary, but it is not yet useful enough.

An event log by itself is only a record of what was seen. The real investigative work begins when different teams start asking different questions of the same history and discover that one timeline is not the same thing as one meaning.

This lesson turns the log into something the inquiry can actually work with: a set of projections that read the same events and tell different stories.

Interactive companion: [`../livebooks/02_competing_projections.livemd`](../livebooks/02_competing_projections.livemd)

## What You'll Learn

By the end of this lesson, you should understand:

- how one event stream can support several read models
- why projections are interpretations rather than truth
- why richer read models do not require changing stored events
- how to keep the write side stable while the read side expands

## The Story

The first Horizon Engine operators quickly discover that a trustworthy log does not answer any questions on its own.

The inquiry now needs to answer several different questions:

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

We will build:

- a reconstructed universe snapshot
- a cosmic timeline projection
- a structure emergence projection
- a causality graph
- an anomaly detector

All of them will read the same event stream.

## The Code

This lesson lives in:

- [`lib/horizon_engine.ex`](./lib/horizon_engine.ex)
- [`lib/event_store.ex`](./lib/event_store.ex)
- [`lib/universe_snapshot.ex`](./lib/universe_snapshot.ex)
- [`lib/cosmic_timeline.ex`](./lib/cosmic_timeline.ex)
- [`lib/structure_emergence.ex`](./lib/structure_emergence.ex)
- [`lib/causality_graph.ex`](./lib/causality_graph.ex)
- [`lib/anomaly_detector.ex`](./lib/anomaly_detector.ex)
- [`test/competing_projections_test.exs`](./test/competing_projections_test.exs)

Core pieces:

```elixir
defmodule HorizonEngine.StructureEmergence do
  def project(events) do
    structures =
      events
      |> Enum.filter(&(&1.type == :mass_collapsed))
      |> Enum.filter(&(get_in(&1, [:attributes, :density]) > 0))
      |> Enum.map(fn event ->
        %{
          sequence: event.sequence,
          region: get_in(event, [:attributes, :region]),
          classification: "proto-well"
        }
      end)

    %{
      first_structure_sequence: first_structure_sequence(structures),
      structures: structures
    }
  end
end
```

```elixir
defmodule HorizonEngine.CausalityGraph do
  def project(events) do
    Map.new(events, fn event ->
      id = get_in(event, [:attributes, :id])
      caused_by = get_in(event, [:attributes, :caused_by]) || []
      {id, caused_by}
    end)
  end
end
```

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
events = HorizonEngine.sample_trace()
HorizonEngine.UniverseSnapshot.project(events)
HorizonEngine.StructureEmergence.project(events)
HorizonEngine.AnomalyDetector.project(events)
```

## What the Tests Prove

The test in [`test/competing_projections_test.exs`](./test/competing_projections_test.exs) proves that one event stream can support:

- a snapshot
- a chronology
- a structure model
- a dependency graph
- an anomaly view

That matters because the reader can see one of event sourcing's biggest advantages directly in code: the write history stays stable while the read side becomes richer.

## Why This Matters

This is the chapter where event sourcing starts to feel different from CRUD.

The log is not just feeding one current-state table.
It is feeding several competing explanations of the same universe.

## Event Sourcing Takeaway

One durable event stream can support many useful projections.

That is one of event sourcing's core advantages:
you do not need to redesign the write side every time the read side gets smarter.

## What Still Hurts

All of these projections still assume the recovered event order is trustworthy enough to replay cleanly.

That assumption is about to fail, and it fails exactly where the inquiry most wants certainty.

## Next Lesson

In [`03_first_replay`](../03_first_replay/README.md), we will keep these projections and add replay logic that branches when the source history is ambiguous.

That is where the inquiry stops being neat.
