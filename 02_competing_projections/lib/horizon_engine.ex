defmodule HorizonEngine do
  @moduledoc """
  Lesson 02 entry points for competing interpretations of the same log.
  """

  alias HorizonEngine.EventStore

  def sample_trace do
    []
    |> EventStore.append(:symmetry_broken, %{id: "e1", field: "inflation-band"})
    |> EventStore.append(:particle_emitted, %{
      id: "e2",
      particle: "matter-seed",
      caused_by: ["e1"]
    })
    |> EventStore.append(:mass_collapsed, %{
      id: "e3",
      region: "perseus-shell",
      density: 9,
      caused_by: ["e2"]
    })
    |> EventStore.append(:energy_spike_recorded, %{
      id: "e4",
      sensor: "lensing-array",
      amplitude: 40,
      caused_by: ["e3"]
    })
    |> EventStore.append(:signal_lost, %{id: "e5", sensor: "north-array", caused_by: ["e4"]})
    |> EventStore.append(:mass_collapsed, %{
      id: "e6",
      region: "ghost-sector",
      density: -3,
      caused_by: ["e5"]
    })
  end
end
