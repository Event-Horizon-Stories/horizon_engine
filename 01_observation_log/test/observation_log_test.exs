defmodule ObservationLogTest do
  use ExUnit.Case

  alias HorizonEngine.CosmicTimeline
  alias HorizonEngine.EventStore
  alias HorizonEngine.UniverseSnapshot

  test "the universe is reconstructed from an append-only log" do
    events =
      []
      |> EventStore.append(:fluctuation_detected, %{sensor: "cmb-array", region: "orion-shear"})
      |> EventStore.append(:particle_emitted, %{particle: "baryon-seed", energy: 12})
      |> EventStore.append(:symmetry_broken, %{field: "electroweak", phase: "split"})

    assert Enum.map(events, & &1.type) == [
             :fluctuation_detected,
             :particle_emitted,
             :symmetry_broken
           ]

    assert CosmicTimeline.project(events) == [
             %{
               sequence: 0,
               type: :fluctuation_detected,
               summary: "Telemetry drift detected by cmb-array in orion-shear"
             },
             %{
               sequence: 1,
               type: :particle_emitted,
               summary: "baryon-seed emitted at energy 12"
             },
             %{
               sequence: 2,
               type: :symmetry_broken,
               summary: "electroweak entered split"
             }
           ]

    assert UniverseSnapshot.project(events) == %{
             event_count: 3,
             first_light?: true,
             structure_possible?: true,
             last_observed_sequence: 2
           }
  end
end
