defmodule CompetingProjections.UniverseSnapshot do
  @moduledoc """
  Carries forward the chapter one snapshot projection.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: structure_possible?(events),
      last_observed_sequence: last_sequence(events),
      anomaly_count: anomaly_count(events)
    }
  end

  defp structure_possible?(events) do
    Enum.any?(events, &(&1.type == :particle_emitted)) and
      Enum.any?(events, &(&1.type in [:symmetry_broken, :mass_collapsed, :structure_seeded]))
  end

  defp last_sequence([]), do: nil
  defp last_sequence(events), do: List.last(events).sequence

  defp anomaly_count(events) do
    Enum.count(events, fn event ->
      event.type == :signal_lost or
        (event.type == :mass_collapsed and get_in(event, [:attributes, :density]) < 0)
    end)
  end
end
