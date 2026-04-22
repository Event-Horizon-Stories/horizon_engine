defmodule HorizonEngine.PreOriginProjection do
  @moduledoc """
  Reinterprets the beginning as a continuation instead of a true start.
  """

  def project(events) do
    anchors =
      events
      |> Enum.filter(&(&1.type == :pre_origin_anchor_inferred))
      |> Enum.map(&get_in(&1, [:attributes, :id]))

    %{
      pre_origin_continuation?: anchors != [],
      anchors: anchors,
      origin_window:
        events
        |> Enum.sort_by(fn event -> {event.tick, Map.get(event, :sequence, -1)} end)
        |> Enum.map(fn event -> %{tick: event.tick, type: event.type} end)
    }
  end
end
