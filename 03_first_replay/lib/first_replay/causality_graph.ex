defmodule FirstReplay.CausalityGraph do
  @moduledoc """
  Carries forward the dependency projection from chapter two.
  """

  def project(events) do
    Map.new(events, fn event ->
      id = get_in(event, [:attributes, :id])
      caused_by = get_in(event, [:attributes, :caused_by]) || []
      {id, caused_by}
    end)
  end
end
