defmodule MissingEpochsTest do
  use ExUnit.Case

  alias HorizonEngine.AnomalyDetector
  alias HorizonEngine.CausalityGraph
  alias HorizonEngine.ContradictionDetector
  alias HorizonEngine.CosmicTimeline
  alias HorizonEngine.GapScanner
  alias HorizonEngine.InferenceProjector
  alias HorizonEngine.Replayer
  alias HorizonEngine.StructureEmergence
  alias HorizonEngine.UniverseSnapshot

  test "gaps in the trace become explicit interpretation problems" do
    events = HorizonEngine.sample_trace()

    assert GapScanner.project(events) == [
             %{from_tick: 2, to_tick: 3}
           ]

    inferred_events = InferenceProjector.project(events)

    assert UniverseSnapshot.project(events) == %{
             event_count: 4,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 3,
             anomaly_count: 1,
             contradiction_count: 0,
             gap_count: 1
           }

    assert CosmicTimeline.project(inferred_events) == [
             %{tick: 0, type: :fluctuation_detected, focus: "sensor cmb-array"},
             %{tick: 1, type: :particle_emitted, focus: "particle matter-seed"},
             %{tick: 2, type: :inferred_missing_event, focus: "gap silence_possible"},
             %{tick: 3, type: :inferred_missing_event, focus: "gap erasure_suspected"},
             %{tick: 4, type: :structure_seeded, focus: "region helix-veil"},
             %{tick: 5, type: :signal_lost, focus: "sensor deep-orbit"}
           ]

    assert StructureEmergence.project(inferred_events) == %{
             first_structure_tick: 4,
             structures: [
               %{tick: 4, region: "helix-veil", classification: "proto-well"}
             ]
           }

    assert CausalityGraph.project(inferred_events) == %{
             "e1" => [],
             "e2" => ["e1"],
             "gap-2" => [],
             "gap-3" => [],
             "e3" => ["e2"],
             "e4" => ["e3"]
           }

    assert AnomalyDetector.project(inferred_events) == [
             "telemetry gap opened at deep-orbit"
           ]

    assert UniverseSnapshot.project(inferred_events) == %{
             event_count: 6,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 5,
             anomaly_count: 1,
             contradiction_count: 0,
             gap_count: 0
           }

    assert Replayer.replay(inferred_events) == [
             [
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :particle_emitted},
               %{tick: 2, type: :inferred_missing_event},
               %{tick: 3, type: :inferred_missing_event},
               %{tick: 4, type: :structure_seeded},
               %{tick: 5, type: :signal_lost}
             ]
           ]

    assert ContradictionDetector.project(inferred_events) == []

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
  end
end
