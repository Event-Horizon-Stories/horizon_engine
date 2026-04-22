defmodule PreOriginModel.InferenceProjector do
  @moduledoc """
  Carries forward explicit placeholder projection for missing epochs.
  """

  alias PreOriginModel.GapScanner

  def project(events) do
    inferred_events =
      events
      |> GapScanner.project()
      |> Enum.with_index(length(events))
      |> Enum.flat_map(&expand_gap(&1, events))

    (events ++ inferred_events)
    |> Enum.sort_by(fn event ->
      {event.tick, inferred_rank(event), Map.get(event, :sequence, -1)}
    end)
  end

  defp expand_gap({%{from_tick: from_tick, to_tick: to_tick}, start_sequence}, events) do
    from_tick..to_tick
    |> Enum.with_index(start_sequence)
    |> Enum.map(fn {tick, sequence} ->
      %{
        sequence: sequence,
        tick: tick,
        type: :inferred_missing_event,
        attributes: %{
          id: "gap-#{tick}",
          caused_by: [],
          classification: classify_gap_tick(tick, events),
          inferred?: true
        }
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
end
