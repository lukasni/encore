defmodule EncoreWeb.ImageServer do
  @moduledoc false

  @root "https://images.evetech.net"

  def portrait(%EVE.Characters.Character{id: id}, size \\ 256) do
    "#{@root}/characters/#{id}/portrait?size=#{size}"
  end
end
