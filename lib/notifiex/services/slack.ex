defmodule Notifiex.Service.Slack do
  @moduledoc """
  Slack service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehavior

  @doc """
  Sends a message to the specified channel.

  `payload` should include the following:
  * `text`: The message text. (required)
  * `channel`: The channel to send the message to. (required)

  `options` should include the following:
  * `token`: Authentication token. (required)
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call(payload, options) when is_map(payload) and is_map(options) do
    url = "https://slack.com/api/chat.postMessage"
    token = Map.get(options, :token)

    send_slack(payload, url, token)
  end

  @spec send_slack(map, binary, binary) :: {:ok, binary} | {:error, {atom, any}}
  defp send_slack(_payload, nil, nil), do: {:error, {:missing_options, nil}}

  defp send_slack(payload, url, token) do
    json_payload = Poison.encode!(payload)

    header = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json; charset=utf-8"},
      {"Authorization", "Bearer " <> token}
    ]

    HTTPoison.start()

    case HTTPoison.post(url, json_payload, header) do
      {:ok, %HTTPoison.Response{body: response, status_code: 200}} ->
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
