# Lesson 02: Competing Projections

In lesson 1, the Horizon Engine learned how to keep a trustworthy event log.

In lesson 2, it learns how to read that same history in more than one way.

Interactive companion: [`../livebooks/02_competing_projections.livemd`](../livebooks/02_competing_projections.livemd)

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

We will build:

- a reconstructed universe snapshot
- a cosmic timeline projection
- a structure emergence projection
- a causality graph
- an anomaly detector

All of them will read the same event stream.

## The Code

This lesson lives in:

- [`lib/competing_projections/event_store.ex`](./lib/competing_projections/event_store.ex)
- [`lib/competing_projections/universe_snapshot.ex`](./lib/competing_projections/universe_snapshot.ex)
- [`lib/competing_projections/cosmic_timeline.ex`](./lib/competing_projections/cosmic_timeline.ex)
- [`lib/competing_projections/structure_emergence.ex`](./lib/competing_projections/structure_emergence.ex)
- [`lib/competing_projections/causality_graph.ex`](./lib/competing_projections/causality_graph.ex)
- [`lib/competing_projections/anomaly_detector.ex`](./lib/competing_projections/anomaly_detector.ex)
- [`test/competing_projections_test.exs`](./test/competing_projections_test.exs)

Core pieces:

```elixir
defmodule CompetingProjections.StructureEmergence do
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
defmodule CompetingProjections.CausalityGraph do
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

That assumption is about to fail.

## Next Lesson

In [`03_first_replay`](../03_first_replay/README.md), we will keep these projections and add replay logic that branches when the source history is ambiguous.

That is where the inquiry stops being neat.
