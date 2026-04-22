defmodule MissingEpochsTest do
  use ExUnit.Case

  alias MissingEpochs.AnomalyDetector
  alias MissingEpochs.CausalityGraph
  alias MissingEpochs.ContradictionDetector
  alias MissingEpochs.CosmicTimeline
  alias MissingEpochs.GapScanner
  alias MissingEpochs.InferenceProjector
  alias MissingEpochs.Replayer
  alias MissingEpochs.StructureEmergence
  alias MissingEpochs.UniverseSnapshot

  test "gaps in the trace become explicit interpretation problems" do
    events = MissingEpochs.sample_trace()

    assert CosmicTimeline.project(events) == [
             %{tick: 0, type: :fluctuation_detected, focus: "sensor cmb-array"},
             %{tick: 1, type: :particle_emitted, focus: "particle matter-seed"},
             %{tick: 4, type: :structure_seeded, focus: "region helix-veil"},
             %{tick: 5, type: :signal_lost, focus: "sensor deep-orbit"}
           ]

    assert StructureEmergence.project(events) == %{
             first_structure_tick: 4,
             structures: [
               %{tick: 4, region: "helix-veil", classification: "proto-well"}
             ]
           }

    assert CausalityGraph.project(events) == %{
             "e1" => [],
             "e2" => ["e1"],
             "e3" => ["e2"],
             "e4" => ["e3"]
           }

    assert AnomalyDetector.project(events) == [
             "telemetry gap opened at deep-orbit"
           ]

    assert UniverseSnapshot.project(events) == %{
             event_count: 4,
             first_light?: true,
             structure_possible?: true,
             gap_count: 1
           }

    assert Replayer.replay(events) == [
             [
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :particle_emitted},
               %{tick: 4, type: :structure_seeded},
               %{tick: 5, type: :signal_lost}
             ]
           ]

    assert ContradictionDetector.project(events) == []

    assert GapScanner.project(events) == [
             %{from_tick: 2, to_tick: 3}
           ]

    assert InferenceProjector.project(events) == [
             %{tick: 0, type: :fluctuation_detected},
             %{tick: 1, type: :particle_emitted},
             %{tick: 2, type: :inferred_missing_event, classification: :silence_possible},
             %{tick: 3, type: :inferred_missing_event, classification: :erasure_suspected},
             %{tick: 4, type: :structure_seeded},
             %{tick: 5, type: :signal_lost}
           ]
  end
end
