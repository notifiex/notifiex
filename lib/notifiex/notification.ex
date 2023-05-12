defmodule Notifiex.Notification do
  @moduledoc """
  Module for notifications.
  """

  @doc """
  `send_notification` sends the notification with the help of the `notification` tuple.

  `notification` should have the following:
  * Service: Slack, etc.
  * Payload
  * Options
  """
  @spec send_notification(Notifiex.config(), Notifiex.send_type()) :: Notifiex.result()
  def send_notification(notification, send_type) do
    # fetch sender
    sender = get_sender(send_type)

    case notification do
      {service, payload, options}
      when is_atom(service) and is_binary(payload) and is_map(options) ->
        sender.(service, payload, options)

      [_] ->
        {:error, {:missing, :payload}}

      _ ->
        {:error, {:invalid, :notification}}
    end
  end

  # sender mappings
  defp get_sender(:sync), do: &Notifiex.send/3
  defp get_sender(:async), do: &Notifiex.send_async/3
end
