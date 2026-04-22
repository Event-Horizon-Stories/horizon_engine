defmodule PreOriginModel.UniverseSnapshot do
  @moduledoc """
  Carries forward the snapshot projection into the final chapter.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: structure_possible?(events),
      last_observed_sequence: last_sequence(events),
      anomaly_count: anomaly_count(events),
      contradiction_count: contradiction_count(events),
      gap_count: gap_count(events),
      pre_origin_anchor_count: Enum.count(events, &(&1.type == :pre_origin_anchor_inferred))
    }
  end

  defp structure_possible?(events) do
    Enum.any?(events, &(&1.type == :particle_emitted)) and
      Enum.any?(events, &(&1.type in [:symmetry_broken, :mass_collapsed, :structure_seeded]))
  end

  defp last_sequence([]), do: nil
  defp last_sequence(events), do: Enum.max_by(events, &Map.get(&1, :sequence, -1)).sequence

  defp anomaly_count(events) do
    Enum.count(events, fn event ->
      event.type == :signal_lost or
        event.type == :pre_origin_anchor_inferred or
        (event.type == :mass_collapsed and get_in(event, [:attributes, :density]) < 0)
    end)
  end

  defp contradiction_count(events) do
    events
    |> Enum.group_by(& &1.tick)
    |> Enum.count(fn {_tick, events_at_tick} ->
      types = Enum.map(events_at_tick, & &1.type) |> Enum.sort()
      types == [:collapse_measured, :expansion_measured]
    end)
  end

  defp gap_count(events) do
    events
    |> Enum.map(& &1.tick)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right - left > 1 end)
  end
end
