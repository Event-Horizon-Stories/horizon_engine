defmodule HorizonEngine.Replayer do
  @moduledoc """
  Replays the trace into candidate timelines when a tick is ambiguous.
  """

  def replay(events) do
    grouped = Enum.group_by(events, & &1.tick)
    ticks = grouped |> Map.keys() |> Enum.sort()

    Enum.reduce(ticks, [[]], fn tick, candidate_timelines ->
      grouped
      |> Map.fetch!(tick)
      |> expand_tick(candidate_timelines)
    end)
    |> Enum.map(&Enum.map(&1, fn event -> %{tick: event.tick, type: event.type} end))
  end

  defp expand_tick(events_at_tick, candidate_timelines) do
    orders = possible_orders(events_at_tick)

    for candidate <- candidate_timelines, ordered_events <- orders do
      candidate ++ ordered_events
    end
  end

  defp possible_orders(events_at_tick) do
    event_types = Enum.map(events_at_tick, & &1.type)

    if Enum.sort(event_types) == [:collapse_measured, :expansion_measured] do
      [
        Enum.sort_by(events_at_tick, &type_rank/1),
        Enum.sort_by(events_at_tick, &reverse_type_rank/1)
      ]
    else
      [Enum.sort_by(events_at_tick, & &1.sequence)]
    end
  end

  defp type_rank(%{type: :expansion_measured}), do: 0
  defp type_rank(%{type: :collapse_measured}), do: 1
  defp type_rank(event), do: event.sequence

  defp reverse_type_rank(%{type: :collapse_measured}), do: 0
  defp reverse_type_rank(%{type: :expansion_measured}), do: 1
  defp reverse_type_rank(event), do: event.sequence
end
