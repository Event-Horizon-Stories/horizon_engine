defmodule HorizonEngine.CosmicTimeline do
  @moduledoc """
  Projects a readable sequence from the raw event log.
  """

  def project(events) do
    events
    |> Enum.sort_by(& &1.sequence)
    |> Enum.map(fn event ->
      %{
        sequence: event.sequence,
        type: event.type,
        summary: summarize(event)
      }
    end)
  end

  defp summarize(%{type: :fluctuation_detected, attributes: %{sensor: sensor, region: region}}) do
    "Telemetry drift detected by #{sensor} in #{region}"
  end

  defp summarize(%{type: :particle_emitted, attributes: %{particle: particle, energy: energy}}) do
    "#{particle} emitted at energy #{energy}"
  end

  defp summarize(%{type: :symmetry_broken, attributes: %{field: field, phase: phase}}) do
    "#{field} entered #{phase}"
  end

  defp summarize(event), do: "#{event.type}"
end
