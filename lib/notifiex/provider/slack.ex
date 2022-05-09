defmodule Notifiex.Provider.Slack do
  @moduledoc """
  Slack provider for Notifiex.
  """

  @behaviour Notifiex.ProviderBehavior

  @doc """
  Sends a message to the specified channel.

  `payload` should include the following:
  * `text`: The message text.
  * `channel`: The channel to send the message to.

  `options` should include the following:
  * `token`: Authentication token.
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call(payload, options) when is_map(payload) and is_map(options) do
    url = "https://slack.com/api/chat.postMessage"
    token = Map.get(options, :token)

    send_slack_notification(payload, url, token)
  end


  @spec send_slack_notification(map, binary, binary) :: {:ok, binary} | {:error, {atom, any}}
  defp send_slack_notification(_payload, nil, nil), do: {:error, {:missing_options, nil}}

  defp send_slack_notification(payload, url, token) do
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
