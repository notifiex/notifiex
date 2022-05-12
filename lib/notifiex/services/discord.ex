defmodule Notifiex.Service.Discord do
  @moduledoc """
  Discord service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehavior

  @doc """
  Sends a message through Webhooks.

  `payload` should include the following:
  * `content`: Message content (up to 2000 characters). (required)

  `options` should include the following:
  * `webhook`: Webhook URI. (required)
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call(payload, options) when is_map(payload) and is_map(options) do
    webhook = Map.get(options, :webhook)

    send_discord(payload, webhook)
  end

  @spec send_discord(map, binary) :: {:ok, binary} | {:error, {atom, any}}
  defp send_discord(_payload, nil), do: {:error, {:missing_options, nil}}

  defp send_discord(payload, url) do
    json_payload = Poison.encode!(payload)

    header = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json; charset=utf-8"}
    ]

    HTTPoison.start()

    case HTTPoison.post(url, json_payload, header) do
      {:ok, %HTTPoison.Response{body: response, status_code: 204}} ->
        {:ok, response}

      {:ok, %HTTPoison.Response{body: response}} ->
        {:error, {:error_response, response}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, {:error, reason}}

      _ = e ->
        {:error, {:unknown_response, e}}
    end
  end
end
