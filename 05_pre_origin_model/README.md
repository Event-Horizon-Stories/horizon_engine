# Lesson 05: The Pre-Origin Model

The Horizon Engine can now name contradictions and gaps without pretending either problem has been solved.

That should be enough to stabilize the investigation.

Instead, the remaining events start doing something impossible: they depend on causes that do not belong in the recovered history at all.

This final lesson is where event sourcing becomes genuinely unsettling. The system does not rewrite the beginning. It appends a new event in the present that changes what the beginning means, as if history were waiting for one more line.

Interactive companion: [`../livebooks/05_pre_origin_model.livemd`](../livebooks/05_pre_origin_model.livemd)

## What You'll Learn

By the end of this lesson, you should understand:

- how newly appended events can reinterpret old history without mutating it
- why event sourcing allows meaning to change while records remain immutable
- how a cumulative tutorial can preserve earlier code while extending its model

## The Story

Some surviving events start depending on a cause that does not belong in the gap at all.
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

We will build:

- a dependency analyzer for unresolved pre-origin references
- a completion step that appends a new anchor event
- a projection that reinterprets the beginning as continuation
- a lesson trace that still works with the earlier gap, replay, and projection tools

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

Core pieces:

```elixir
defmodule PreOriginModel.DependencyAnalyzer do
  def project(events) do
    known_ids =
      events
      |> Enum.map(&get_in(&1, [:attributes, :id]))
      |> MapSet.new()

    events
    |> Enum.flat_map(fn event ->
      dependency = get_in(event, [:attributes, :depends_on])

      cond do
        is_nil(dependency) -> []
        MapSet.member?(known_ids, dependency) -> []
        true -> [%{event_id: get_in(event, [:attributes, :id]), missing_dependency: dependency}]
      end
    end)
  end
end
```

```elixir
defmodule PreOriginModel.HorizonCompleter do
  def complete(events) do
    DependencyAnalyzer.project(events)
    |> Enum.reduce(events, fn dependency, acc ->
      EventStore.append(acc, :pre_origin_anchor_inferred, -1, %{
        id: dependency.missing_dependency,
        emitted_by: "horizon-engine",
        resolves_future_event: dependency.event_id
      })
    end)
  end
end
```

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
completed =
  events
  |> PreOriginModel.InferenceProjector.project()
  |> PreOriginModel.HorizonCompleter.complete()

PreOriginModel.PreOriginProjection.project(completed)
```

## What the Tests Prove

The test in [`test/pre_origin_model_test.exs`](./test/pre_origin_model_test.exs) proves the final move:

- the engine can append a new pre-origin anchor event
- the gap and projection layers from earlier lessons still work on the same completed timeline
- the meaning of the beginning changes without rewriting any earlier event

That is the deepest event-sourcing turn in the series.

## Why This Matters

The log remains the only truth surface, but the meaning of the past is still alive.

That is why event sourcing fits this story so well:
history stays immutable while understanding keeps changing.

## Event Sourcing Takeaway

New events can change the interpretation of old history without mutating the old records.

That is the deepest event-sourcing move in the series:
immutability and reinterpretation are not opposites. They are partners.

## What Still Hurts

The implementation works, but the world is not resolved.

The open questions are the point now:

- are the inferred anchors discoveries or inventions?
- why do present-day completions fit the ancient trace so perfectly?
- is the Horizon Engine reconstructing the universe or helping complete it?

## Where The Series Could Go Next

If the series continues, the next chapter should probably explore rival engines, contested completions, or operator workflows for accepting and rejecting inferred pre-origin events.

That would keep the code cumulative while pushing the reality problem even further.
