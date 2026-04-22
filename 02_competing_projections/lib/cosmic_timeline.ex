defmodule HorizonEngine.CosmicTimeline do
  @moduledoc """
  Reads the log as a plain ordered chronology.
  """

  def project(events) do
    Enum.map(events, fn event ->
      %{
        sequence: event.sequence,
        type: event.type,
        focus: focus(event)
      }
    end)
  end

  defp focus(%{type: :symmetry_broken, attributes: %{field: field}}), do: "field #{field}"

  defp focus(%{type: :particle_emitted, attributes: %{particle: particle}}),
    do: "particle #{particle}"

  defp focus(%{type: :mass_collapsed, attributes: %{region: region}}), do: "region #{region}"

  defp focus(%{type: :energy_spike_recorded, attributes: %{sensor: sensor}}),
    do: "sensor #{sensor}"

  defp focus(%{type: :signal_lost, attributes: %{sensor: sensor}}), do: "sensor #{sensor}"
  defp focus(_event), do: "unknown"
end
