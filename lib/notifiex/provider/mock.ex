defmodule Notifiex.Provider.Mock do
  @moduledoc """
  Mock provider for Notifiex.
  """

  @behaviour Notifiex.ProviderBehavior

  @doc """
  Mock provider returns `{:ok, true}` if payload is `{hello: "world"}`, else returns an error response: `{:error, :mock_error, false}`.
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call(%{hello: "world"}, _), do: {:ok, true}
  def call(_, _), do: {:error, {:mock_error, false}}
end
