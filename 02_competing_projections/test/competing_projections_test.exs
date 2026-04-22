defmodule CompetingProjectionsTest do
  use ExUnit.Case

  alias HorizonEngine.AnomalyDetector
  alias HorizonEngine.CausalityGraph
  alias HorizonEngine.CosmicTimeline
  alias HorizonEngine.StructureEmergence
  alias HorizonEngine.UniverseSnapshot

  test "different projections tell different stories about the same universe" do
    events = HorizonEngine.sample_trace()

    assert CosmicTimeline.project(events) == [
             %{sequence: 0, type: :symmetry_broken, focus: "field inflation-band"},
             %{sequence: 1, type: :particle_emitted, focus: "particle matter-seed"},
             %{sequence: 2, type: :mass_collapsed, focus: "region perseus-shell"},
             %{sequence: 3, type: :energy_spike_recorded, focus: "sensor lensing-array"},
             %{sequence: 4, type: :signal_lost, focus: "sensor north-array"},
             %{sequence: 5, type: :mass_collapsed, focus: "region ghost-sector"}
           ]

    assert StructureEmergence.project(events) == %{
             first_structure_sequence: 2,
             structures: [
               %{sequence: 2, region: "perseus-shell", classification: "proto-well"}
             ]
           }

    assert CausalityGraph.project(events) == %{
             "e1" => [],
             "e2" => ["e1"],
             "e3" => ["e2"],
             "e4" => ["e3"],
             "e5" => ["e4"],
             "e6" => ["e5"]
           }

    assert AnomalyDetector.project(events) == [
             "telemetry gap opened at north-array",
             "negative mass collapse recorded in ghost-sector"
           ]

    assert UniverseSnapshot.project(events) == %{
             event_count: 6,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 5,
             anomaly_count: 2
           }
  end
end
