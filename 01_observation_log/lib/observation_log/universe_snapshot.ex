defmodule ObservationLog.UniverseSnapshot do
  @moduledoc """
  Derives an interpreted state from raw events.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: structure_possible?(events),
      last_observed_sequence: last_sequence(events)
    }
  end

  defp structure_possible?(events) do
    Enum.any?(events, &(&1.type == :symmetry_broken)) and
      Enum.any?(events, &(&1.type == :particle_emitted))
  end

  defp last_sequence([]), do: nil
  defp last_sequence(events), do: List.last(events).sequence
end
