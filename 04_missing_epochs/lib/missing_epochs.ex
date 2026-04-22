defmodule MissingEpochs do
  @moduledoc """
  Lesson 04 entry points for missing sections of the universal log.
  """

  alias MissingEpochs.EventStore

  def sample_trace do
    []
    |> EventStore.append(:fluctuation_detected, 0, %{id: "e1", sensor: "cmb-array"})
    |> EventStore.append(:particle_emitted, 1, %{
      id: "e2",
      particle: "matter-seed",
      caused_by: ["e1"]
    })
    |> EventStore.append(:structure_seeded, 4, %{
      id: "e3",
      region: "helix-veil",
      depends_on_tick: 3,
      caused_by: ["e2"]
    })
    |> EventStore.append(:signal_lost, 5, %{id: "e4", sensor: "deep-orbit", caused_by: ["e3"]})
  end
end
