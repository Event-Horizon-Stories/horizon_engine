defmodule PreOriginModelTest do
  use ExUnit.Case

  alias PreOriginModel.AnomalyDetector
  alias PreOriginModel.CausalityGraph
  alias PreOriginModel.ContradictionDetector
  alias PreOriginModel.CosmicTimeline
  alias PreOriginModel.DependencyAnalyzer
  alias PreOriginModel.GapScanner
  alias PreOriginModel.HorizonCompleter
  alias PreOriginModel.InferenceProjector
  alias PreOriginModel.PreOriginProjection
  alias PreOriginModel.Replayer
  alias PreOriginModel.StructureEmergence
  alias PreOriginModel.UniverseSnapshot

  test "the engine starts appending events that seem to belong before the beginning" do
    events = PreOriginModel.sample_trace()

    assert GapScanner.project(events) == [
             %{from_tick: 2, to_tick: 3}
           ]

    inferred_events = InferenceProjector.project(events)

    assert StructureEmergence.project(inferred_events) == %{
             first_structure_tick: 4,
             structures: [
               %{tick: 4, region: "helix-veil", classification: "proto-well"}
             ]
           }

    assert Enum.map(inferred_events, fn event ->
             {event.tick, event.type, get_in(event, [:attributes, :classification])}
           end) == [
             {0, :fluctuation_detected, nil},
             {1, :particle_emitted, nil},
             {2, :inferred_missing_event, :silence_possible},
             {3, :inferred_missing_event, :erasure_suspected},
             {4, :structure_seeded, nil},
             {5, :signal_lost, nil}
           ]

    assert DependencyAnalyzer.project(inferred_events) == [
             %{event_id: "e2", missing_dependency: "anchor-0", before_tick: 1}
           ]

    completed_events = HorizonCompleter.complete(inferred_events)

    assert List.last(completed_events) == %{
             sequence: 6,
             tick: -1,
             type: :pre_origin_anchor_inferred,
             attributes: %{
               id: "anchor-0",
               emitted_by: "horizon-engine",
               resolves_future_event: "e2"
             }
           }

    assert CosmicTimeline.project(completed_events) == [
             %{tick: -1, type: :pre_origin_anchor_inferred, focus: "anchor anchor-0"},
             %{tick: 0, type: :fluctuation_detected, focus: "sensor cmb-array"},
             %{tick: 1, type: :particle_emitted, focus: "particle matter-seed"},
             %{tick: 2, type: :inferred_missing_event, focus: "gap silence_possible"},
             %{tick: 3, type: :inferred_missing_event, focus: "gap erasure_suspected"},
             %{tick: 4, type: :structure_seeded, focus: "region helix-veil"},
             %{tick: 5, type: :signal_lost, focus: "sensor deep-orbit"}
           ]

    assert CausalityGraph.project(completed_events) == %{
             "e1" => [],
             "e2" => ["anchor-0"],
             "gap-2" => [],
             "gap-3" => [],
             "e3" => ["e2"],
             "e4" => ["e3"],
             "anchor-0" => []
           }

    assert AnomalyDetector.project(completed_events) == [
             "telemetry gap opened at deep-orbit",
             "pre-origin anchor inferred for anchor-0"
           ]

    assert UniverseSnapshot.project(completed_events) == %{
             event_count: 7,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 6,
             anomaly_count: 2,
             contradiction_count: 0,
             gap_count: 0,
             pre_origin_anchor_count: 1
           }

    assert Replayer.replay(completed_events) == [
             [
               %{tick: -1, type: :pre_origin_anchor_inferred},
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :particle_emitted},
               %{tick: 2, type: :inferred_missing_event},
               %{tick: 3, type: :inferred_missing_event},
               %{tick: 4, type: :structure_seeded},
               %{tick: 5, type: :signal_lost}
             ]
           ]

    assert ContradictionDetector.project(completed_events) == []

    assert PreOriginProjection.project(completed_events) == %{
             pre_origin_continuation?: true,
             anchors: ["anchor-0"],
             origin_window: [
               %{tick: -1, type: :pre_origin_anchor_inferred},
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :particle_emitted},
               %{tick: 2, type: :inferred_missing_event},
               %{tick: 3, type: :inferred_missing_event},
               %{tick: 4, type: :structure_seeded},
               %{tick: 5, type: :signal_lost}
             ]
           }
  end
end
