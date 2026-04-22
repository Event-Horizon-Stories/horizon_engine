defmodule PreOriginModel.Replayer do
  @moduledoc """
  Carries forward replay into the final chapter.
  """

  def replay(events) do
    [
      events
      |> Enum.sort_by(fn event -> {event.tick, Map.get(event, :sequence, -1)} end)
      |> Enum.map(fn event -> %{tick: event.tick, type: event.type} end)
    ]
  end
end
