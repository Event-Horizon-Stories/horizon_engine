defmodule HorizonEngine.AnomalyDetector do
  @moduledoc """
  Carries forward anomaly detection into the final chapter.
  """

  def project(events) do
    Enum.flat_map(events, &detect/1)
  end

  defp detect(%{type: :signal_lost, attributes: %{sensor: sensor}}) do
    ["telemetry gap opened at #{sensor}"]
  end

  defp detect(%{type: :pre_origin_anchor_inferred, attributes: %{id: id}}) do
    ["pre-origin anchor inferred for #{id}"]
  end

  defp detect(_event), do: []
end
