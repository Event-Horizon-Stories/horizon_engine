defmodule FirstReplay do
  @moduledoc """
  Lesson 03 entry points for ambiguous replay.
  """

  alias FirstReplay.EventStore

  def sample_trace do
    []
    |> EventStore.append(:fluctuation_detected, 0, %{id: "e1", sensor: "cmb-array"})
    |> EventStore.append(:expansion_measured, 1, %{
      id: "e2",
      sensor: "redshift-ring",
      caused_by: ["e1"]
    })
    |> EventStore.append(:collapse_measured, 1, %{
      id: "e3",
      sensor: "gravity-well",
      caused_by: ["e1"]
    })
    |> EventStore.append(:particle_emitted, 2, %{
      id: "e4",
      particle: "lumen-seed",
      caused_by: ["e2"]
    })
    |> EventStore.append(:mass_collapsed, 3, %{
      id: "e5",
      region: "perseus-shell",
      density: 9,
      caused_by: ["e4"]
    })
    |> EventStore.append(:signal_lost, 4, %{id: "e6", sensor: "deep-orbit", caused_by: ["e5"]})
  end
end
