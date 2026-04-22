defmodule HorizonEngine.CosmicTimeline do
  @moduledoc """
  Carries forward the chronological projection from chapter two.
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

  defp focus(%{type: :expansion_measured, attributes: %{sensor: sensor}}), do: "sensor #{sensor}"
  defp focus(%{type: :collapse_measured, attributes: %{sensor: sensor}}), do: "sensor #{sensor}"

  defp focus(%{type: :particle_emitted, attributes: %{particle: particle}}),
    do: "particle #{particle}"

  defp focus(%{type: :mass_collapsed, attributes: %{region: region}}), do: "region #{region}"
  defp focus(%{type: :signal_lost, attributes: %{sensor: sensor}}), do: "sensor #{sensor}"
  defp focus(_event), do: "unknown"
end
