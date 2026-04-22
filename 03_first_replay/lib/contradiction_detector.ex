defmodule HorizonEngine.ContradictionDetector do
  @moduledoc """
  Flags ticks that contain mutually exclusive observations.
  """

  def project(events) do
    events
    |> Enum.group_by(& &1.tick)
    |> Enum.flat_map(fn {tick, events_at_tick} ->
      types = events_at_tick |> Enum.map(& &1.type) |> Enum.sort()

      case types do
        [:collapse_measured, :expansion_measured] ->
          [
            %{
              tick: tick,
              conflicting_types: types,
              message: "expansion and collapse were recorded at the same moment"
            }
          ]

        _ ->
          []
      end
    end)
  end
end
