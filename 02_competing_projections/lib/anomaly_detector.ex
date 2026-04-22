defmodule HorizonEngine.AnomalyDetector do
  @moduledoc """
  Flags observations that do not fit the working cosmology.
  """

  def project(events) do
    events
    |> Enum.flat_map(&detect/1)
  end

  defp detect(%{type: :mass_collapsed, attributes: %{region: region, density: density}})
       when density < 0 do
    ["negative mass collapse recorded in #{region}"]
  end

  defp detect(%{type: :signal_lost, attributes: %{sensor: sensor}}) do
    ["telemetry gap opened at #{sensor}"]
  end

  defp detect(_event), do: []
end
