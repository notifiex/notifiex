defmodule Notifiex.Service.Slack do
  @moduledoc """
  Slack service for Notifiex.
  """

  @behaviour Notifiex.ServiceBehaviour
  @type payload :: %{required(:text) => binary, required(:channel) => binary}
  @type options :: %{
          required(:token) => binary,
          optional(:channel_ids) => any,
          optional(:files) => any
        }

  @doc """
  Sends a message to the specified channel.

  `payload` should include the following:
  * `text`: The message text. (required)
  * `channel`: The channel to send the message to. (required)

  `options` should include the following:
  * `token`: Authentication token. (required)
  * `channel_ids`: List of channel IDs for file upload (optional)
  * `files`: List of files to be uploaded (optional)
  """
  @spec call(payload(), options()) :: Notifiex.result()
  def call(payload, options)

  def call(payload = %{"text" => _, "channel" => _}, options = %{"token" => token})
      when is_map(payload) and is_map(options) do
    IO.puts("text #{Map.get(payload, :text)}")
    url = "https://slack.com/api/chat.postMessage"

    # send message (without file)
    result = send_message(payload, url, token)

    # fetch channels and files
    channels = Map.get(options, :channel_ids)
    files = Map.get(options, :files)

    # Send each file through the files.upload API
    if is_nil(files) do
      result
    else
      for file <- files do
        if String.trim(file) != "" do
          send_files(file, channels, token)
        end
      end
    end
  end

  def call(_, _), do: {:error, {:missing_required_params}, nil}

  @spec send_message(map, binary, binary) :: Notifiex.result()
  defp send_message(payload, url, token) do
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

  @spec send_files(binary, binary, binary) :: Notifiex.result()
  defp send_files(files, channels, token) do
    header = [
      {"Authorization", "Bearer " <> token}
    ]

    HTTPoison.start()

    # create a multipart request with files and channel IDs
    request = %HTTPoison.Request{
      method: :post,
      url: "https://slack.com/api/files.upload",
      headers: header,
      body:
        {:multipart,
         [
           {:file, files},
           {"channels", channels}
         ]}
    }

    response = HTTPoison.request(request)

    case response do
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
