defmodule HorizonEngine.Replayer do
  @moduledoc """
  Carries forward replay, which is still useful even when no contradictions exist.
  """

  def replay(events) do
    grouped = Enum.group_by(events, & &1.tick)
    ticks = grouped |> Map.keys() |> Enum.sort()

    Enum.reduce(ticks, [[]], fn tick, candidate_timelines ->
      events_at_tick = Map.fetch!(grouped, tick)

      for candidate <- candidate_timelines do
        candidate ++ Enum.sort_by(events_at_tick, &Map.get(&1, :sequence, -1))
      end
    end)
    |> Enum.map(&Enum.map(&1, fn event -> %{tick: event.tick, type: event.type} end))
  end
end
