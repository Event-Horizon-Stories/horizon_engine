defmodule HorizonEngine.StructureEmergence do
  @moduledoc """
  Interprets which collapses look like the first durable structures.
  """

  def project(events) do
    structures =
      events
      |> Enum.filter(&(&1.type == :mass_collapsed))
      |> Enum.filter(&(get_in(&1, [:attributes, :density]) > 0))
      |> Enum.map(fn event ->
        %{
          sequence: event.sequence,
          region: get_in(event, [:attributes, :region]),
          classification: "proto-well"
        }
      end)

    %{
      first_structure_sequence: first_structure_sequence(structures),
      structures: structures
    }
  end

  defp first_structure_sequence([]), do: nil
  defp first_structure_sequence([structure | _rest]), do: structure.sequence
end
