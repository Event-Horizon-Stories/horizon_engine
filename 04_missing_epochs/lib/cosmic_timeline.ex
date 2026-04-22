defmodule HorizonEngine.CosmicTimeline do
  @moduledoc """
  Carries forward the chronological projection.
  """

  def project(events) do
    Enum.map(events, fn event ->
      %{
        tick: event.tick,
        type: event.type,
        focus: focus(event)
      }
    end)
  end

  defp focus(%{type: :fluctuation_detected, attributes: %{sensor: sensor}}),
    do: "sensor #{sensor}"

  defp focus(%{type: :particle_emitted, attributes: %{particle: particle}}),
    do: "particle #{particle}"

  defp focus(%{type: :inferred_missing_event, attributes: %{classification: classification}}),
    do: "gap #{classification}"

  defp focus(%{type: :structure_seeded, attributes: %{region: region}}), do: "region #{region}"
  defp focus(%{type: :signal_lost, attributes: %{sensor: sensor}}), do: "sensor #{sensor}"
  defp focus(_event), do: "unknown"
end
