defmodule Notifiex.Service.Mock do
  @moduledoc """
  Mock service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehaviour

  @doc """
  Mock service returns `{:ok, true}` if payload is `{hello: "world"}`, else returns an error response: `{:error, :mock_error, false}`.
  """
  @spec call(map, map) :: Notifiex.result()
  def call(%{hello: "world"}, _), do: {:ok, true}
  def call(_, _), do: {:error, {:mock_error, false}}
end
