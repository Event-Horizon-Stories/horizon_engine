defmodule PreOriginModel.UniverseSnapshot do
  @moduledoc """
  Carries forward the snapshot projection into the final chapter.
  """

  def project(events) do
    %{
      event_count: length(events),
      first_light?: Enum.any?(events, &(&1.type == :particle_emitted)),
      structure_possible?: Enum.any?(events, &(&1.type in [:mass_collapsed, :structure_seeded])),
      pre_origin_anchor_count: Enum.count(events, &(&1.type == :pre_origin_anchor_inferred))
    }
  end
end
