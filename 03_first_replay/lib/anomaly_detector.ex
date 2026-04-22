defmodule HorizonEngine.AnomalyDetector do
  @moduledoc """
  Carries forward anomaly detection while replay becomes ambiguous.
  """

  def project(events) do
    Enum.flat_map(events, &detect/1)
  end

  defp detect(%{type: :signal_lost, attributes: %{sensor: sensor}}) do
    ["telemetry gap opened at #{sensor}"]
  end

  defp detect(_event), do: []
end
