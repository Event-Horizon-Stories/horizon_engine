defmodule HorizonEngine.HorizonCompleter do
  @moduledoc """
  Emits new events that attempt to complete unresolved origin dependencies.
  """

  alias HorizonEngine.DependencyAnalyzer
  alias HorizonEngine.EventStore

  def complete(events) do
    DependencyAnalyzer.project(events)
    |> Enum.reduce(events, fn dependency, acc ->
      EventStore.append(acc, :pre_origin_anchor_inferred, -1, %{
        id: dependency.missing_dependency,
        emitted_by: "horizon-engine",
        resolves_future_event: dependency.event_id
      })
    end)
  end
end
