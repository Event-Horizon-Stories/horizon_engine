defmodule CompetingProjections.UniverseSnapshot do
  @moduledoc """
  Carries forward the chapter one snapshot projection.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: Enum.any?(events, &(&1.type == :mass_collapsed)),
      anomaly_count: anomaly_count(events)
    }
  end

  defp anomaly_count(events) do
    Enum.count(events, fn event ->
      event.type == :signal_lost or
        (event.type == :mass_collapsed and get_in(event, [:attributes, :density]) < 0)
    end)
  end
end
