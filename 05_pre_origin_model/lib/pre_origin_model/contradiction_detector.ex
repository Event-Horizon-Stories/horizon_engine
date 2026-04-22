defmodule PreOriginModel.ContradictionDetector do
  @moduledoc """
  Carries forward contradiction checks.
  """

  def project(events) do
    events
    |> Enum.group_by(& &1.tick)
    |> Enum.flat_map(fn {tick, events_at_tick} ->
      types = Enum.map(events_at_tick, & &1.type) |> Enum.sort()

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
