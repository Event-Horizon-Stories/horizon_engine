defmodule PreOriginModel.InferenceProjector do
  @moduledoc """
  Carries forward explicit placeholder projection for missing epochs.
  """

  alias PreOriginModel.GapScanner

  def project(events) do
    inferred_events =
      events
      |> GapScanner.project()
      |> Enum.flat_map(&expand_gap(&1, events))

    (events ++ inferred_events)
    |> Enum.sort_by(fn event -> {event.tick, inferred_rank(event), Map.get(event, :sequence, -1)} end)
    |> Enum.map(&normalize/1)
  end

  defp expand_gap(%{from_tick: from_tick, to_tick: to_tick}, events) do
    Enum.map(from_tick..to_tick, fn tick ->
      %{
        tick: tick,
        type: :inferred_missing_event,
        classification: classify_gap_tick(tick, events)
      }
    end)
  end

  defp classify_gap_tick(tick, events) do
    if Enum.any?(events, &(get_in(&1, [:attributes, :depends_on_tick]) == tick)) do
      :erasure_suspected
    else
      :silence_possible
    end
  end

  defp inferred_rank(%{type: :inferred_missing_event}), do: 0
  defp inferred_rank(_event), do: 1

  defp normalize(%{type: :inferred_missing_event, tick: tick, classification: classification}) do
    %{tick: tick, type: :inferred_missing_event, classification: classification}
  end

  defp normalize(event) do
    %{tick: event.tick, type: event.type}
  end
end
