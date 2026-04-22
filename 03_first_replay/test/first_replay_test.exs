defmodule FirstReplayTest do
  use ExUnit.Case

  alias HorizonEngine.AnomalyDetector
  alias HorizonEngine.CausalityGraph
  alias HorizonEngine.ContradictionDetector
  alias HorizonEngine.CosmicTimeline
  alias HorizonEngine.Replayer
  alias HorizonEngine.StructureEmergence
  alias HorizonEngine.UniverseSnapshot

  test "replaying from time zero can yield multiple valid timelines" do
    events = HorizonEngine.sample_trace()

    assert CosmicTimeline.project(events) == [
             %{tick: 0, type: :fluctuation_detected, focus: "sensor cmb-array"},
             %{tick: 1, type: :expansion_measured, focus: "sensor redshift-ring"},
             %{tick: 1, type: :collapse_measured, focus: "sensor gravity-well"},
             %{tick: 2, type: :particle_emitted, focus: "particle lumen-seed"},
             %{tick: 3, type: :mass_collapsed, focus: "region perseus-shell"},
             %{tick: 4, type: :signal_lost, focus: "sensor deep-orbit"}
           ]

    assert StructureEmergence.project(events) == %{
             first_structure_tick: 3,
             structures: [
               %{tick: 3, region: "perseus-shell", classification: "proto-well"}
             ]
           }

    assert CausalityGraph.project(events) == %{
             "e1" => [],
             "e2" => ["e1"],
             "e3" => ["e1"],
             "e4" => ["e2"],
             "e5" => ["e4"],
             "e6" => ["e5"]
           }

    assert AnomalyDetector.project(events) == [
             "telemetry gap opened at deep-orbit"
           ]

    assert UniverseSnapshot.project(events) == %{
             event_count: 6,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 5,
             anomaly_count: 1,
             contradiction_count: 1
           }

    assert Replayer.replay(events) == [
             [
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :expansion_measured},
               %{tick: 1, type: :collapse_measured},
               %{tick: 2, type: :particle_emitted},
               %{tick: 3, type: :mass_collapsed},
               %{tick: 4, type: :signal_lost}
             ],
             [
               %{tick: 0, type: :fluctuation_detected},
               %{tick: 1, type: :collapse_measured},
               %{tick: 1, type: :expansion_measured},
               %{tick: 2, type: :particle_emitted},
               %{tick: 3, type: :mass_collapsed},
               %{tick: 4, type: :signal_lost}
             ]
           ]

    assert ContradictionDetector.project(events) == [
             %{
               tick: 1,
               conflicting_types: [:collapse_measured, :expansion_measured],
               message: "expansion and collapse were recorded at the same moment"
             }
           ]
  end
end
