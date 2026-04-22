defmodule FirstReplay.EventStore do
  @moduledoc """
  Append-only event storage with coarse cosmic ticks.
  """

  def append(events, type, tick, attributes) when is_list(events) and is_atom(type) do
    sequence = length(events)

    event = %{
      sequence: sequence,
      tick: tick,
      type: type,
      attributes: Map.new(attributes)
    }

    events ++ [event]
  end
end
