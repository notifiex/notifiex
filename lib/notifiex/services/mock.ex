defmodule Notifiex.Service.Mock do
  @moduledoc """
  Mock service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehaviour

  @doc """
  Mock service returns `{:ok, true}` if payload is `{hello: "world"}`, else returns an error response: `{:error, :mock_error, false}`.
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call("", _), do: {:error, {:mock_error, false}}
  def call(payload, _), do: {:ok, true}
end
