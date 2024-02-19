defmodule Notifiex.Service.Discord do
  @moduledoc """
  Discord service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehaviour
  @type payload :: %{required(:content) => binary}
  @type options :: %{required(:webhook) => binary}

  @doc """
  Sends a message through Webhooks.

  `payload` should include the following:
  * `content`: Message content (up to 2000 characters). (required)

  `options` should include the following:
  * `webhook`: Webhook URI. (required)
  """
  @spec call(payload(), payload()) :: Notifiex.result()
  def call(payload = %{"content" => _}, options = %{"webhook" => webhook})
      when is_map(payload) and is_map(options) do
    send_discord(payload, webhook)
  end

  def call(_, _), do: {:error, {:missing_required_params}, nil}

  @spec send_discord(map, binary) :: Notifiex.result()
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
