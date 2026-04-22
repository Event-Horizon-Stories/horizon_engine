defmodule PreOriginModel.GapScanner do
  @moduledoc """
  Carries forward gap scanning into the final chapter.
  """

  def project(events) do
    ticks = Enum.map(events, & &1.tick)

    ticks
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(fn [left, right] ->
      if right - left > 1 do
        [%{from_tick: left + 1, to_tick: right - 1}]
      else
        []
      end
    end)
  end
end
