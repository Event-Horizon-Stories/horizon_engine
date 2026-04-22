defmodule HorizonEngine.EventStore do
  @moduledoc """
  Append-only storage for raw universal observations.
  """

  def append(events, type, attributes, opts \\ []) when is_list(events) and is_atom(type) do
    sequence = length(events)

    event = %{
      sequence: sequence,
      type: type,
      observed_at: Keyword.get(opts, :observed_at, sequence),
      attributes: Map.new(attributes)
    }

    events ++ [event]
  end
end
