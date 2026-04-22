defmodule HorizonEngine do
  @moduledoc """
  Lesson 05 entry points for the pre-origin hypothesis.
  """

  alias HorizonEngine.EventStore

  def sample_trace do
    []
    |> EventStore.append(:fluctuation_detected, 0, %{id: "e1", sensor: "cmb-array"})
    |> EventStore.append(:particle_emitted, 1, %{
      id: "e2",
      particle: "matter-seed",
      depends_on: "anchor-0",
      caused_by: ["anchor-0"]
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
