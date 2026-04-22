defmodule HorizonEngine.DependencyAnalyzer do
  @moduledoc """
  Finds events that reference causes missing from the trace.
  """

  def project(events) do
    known_ids =
      events
      |> Enum.map(&get_in(&1, [:attributes, :id]))
      |> MapSet.new()

    events
    |> Enum.flat_map(fn event ->
      dependency = get_in(event, [:attributes, :depends_on])

      cond do
        is_nil(dependency) ->
          []

        MapSet.member?(known_ids, dependency) ->
          []

        true ->
          [
            %{
              event_id: get_in(event, [:attributes, :id]),
              missing_dependency: dependency,
              before_tick: event.tick
            }
          ]
      end
    end)
  end
end
