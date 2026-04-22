defmodule FirstReplay.StructureEmergence do
  @moduledoc """
  Carries forward the structure-emergence projection from chapter two.
  """

  def project(events) do
    structures =
      events
      |> Enum.filter(&(&1.type == :mass_collapsed))
      |> Enum.filter(&(get_in(&1, [:attributes, :density]) > 0))
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
