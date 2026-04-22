defmodule ObservationLog do
  @moduledoc """
  Lesson 01 entry points for the Horizon Engine story.
  """

  alias ObservationLog.EventStore

  def sample_trace do
    []
    |> EventStore.append(:fluctuation_detected, %{sensor: "cmb-array", region: "orion-shear"})
    |> EventStore.append(:particle_emitted, %{particle: "baryon-seed", energy: 12})
    |> EventStore.append(:symmetry_broken, %{field: "electroweak", phase: "split"})
  end
end
