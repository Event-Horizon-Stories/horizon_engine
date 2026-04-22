defmodule FirstReplay.UniverseSnapshot do
  @moduledoc """
  Carries forward the chapter one snapshot projection.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: Enum.any?(events, &(&1.type == :mass_collapsed)),
      contradiction_count: contradiction_count(events)
    }
  end

  defp contradiction_count(events) do
    events
    |> Enum.group_by(& &1.tick)
    |> Enum.count(fn {_tick, events_at_tick} ->
      types = Enum.map(events_at_tick, & &1.type) |> Enum.sort()
      types == [:collapse_measured, :expansion_measured]
    end)
  end
end
