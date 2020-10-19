defmodule Ecto.MapSet do
  @moduledoc false

  use Ecto.ParameterizedType

  def type(%{type: inner_type}), do: {:array, inner_type}

  def init(opts) do
    case Map.new(opts) do
      %{type: type} ->
        %{type: type}

      _ ->
        raise ArgumentError, """
        Ecto.MapSet types must have a type options specified as an atom. For example:

            field :my_field, Ecto.MapSet, type: :string
        """
    end
  end

  def cast(list ,_params) when is_list(list) do
    {:ok, MapSet.new(list)}
  end

  def cast(%MapSet{} = map_set, _params), do: {:ok, map_set}

  def cast(_, _), do: :error

  def equal?(a, b, _) when is_nil(a) or is_nil(b), do: false
  def equal?(a, b, _params) do
    MapSet.equal?(a, b)
  end

  def load(data, _, _) when is_list(data) do
    {:ok, MapSet.new(data)}
  end

  def dump(%MapSet{} = map_set, _, _), do: {:ok, MapSet.to_list(map_set)}
  def dump(_, _, _), do: :error
end
