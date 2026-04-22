defmodule MissingEpochs.UniverseSnapshot do
  @moduledoc """
  Carries forward the chapter one snapshot projection.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: Enum.any?(events, &(&1.type in [:mass_collapsed, :structure_seeded])),
      gap_count: gap_count(events)
    }
  end

  defp gap_count(events) do
    events
    |> Enum.map(& &1.tick)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right - left > 1 end)
  end
end
