defmodule HorizonEngine.EventStore do
  @moduledoc """
  Append-only storage for chapter two.
  """

  def append(events, type, attributes) when is_list(events) and is_atom(type) do
    sequence = length(events)

    event = %{
      sequence: sequence,
      type: type,
      attributes: Map.new(attributes)
    }

    events ++ [event]
  end
end
