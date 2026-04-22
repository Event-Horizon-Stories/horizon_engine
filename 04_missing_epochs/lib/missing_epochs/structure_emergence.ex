defmodule MissingEpochs.StructureEmergence do
  @moduledoc """
  Carries forward the structure projection into the gap chapter.
  """

  def project(events) do
    structures =
      events
      |> Enum.filter(&(&1.type in [:mass_collapsed, :structure_seeded]))
      |> Enum.map(fn event ->
        %{
          tick: event.tick,
          region: get_in(event, [:attributes, :region]),
          classification: "proto-well"
        }
      end)

    %{
      first_structure_tick: first_structure_tick(structures),
      structures: structures
    }
  end

  defp first_structure_tick([]), do: nil
  defp first_structure_tick([structure | _rest]), do: structure.tick
end
