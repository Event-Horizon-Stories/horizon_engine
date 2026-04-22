defmodule HorizonEngine.EventStore do
  @moduledoc """
  Append-only storage for the final lesson.
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
