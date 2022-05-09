defmodule Notifiex.Notification do
  @moduledoc """
  Module for notifications.
  """

  defmacro __using__(_) do
    quote do
      @behavior Notifiex.NotificationBehavior

      alias Notifiex.Notification

      @doc """
      `send` sends the notification in a synchronous way.
      """
      @spec send(any) :: [{Notifiex.id(), Notifiex.result()}]
      def send(opts) do
        Notification.send_notification(opts, :sync)
      end
    end
  end

  @doc """
  `send_notification` sends the notification with the help of the `notification` tuple.

  `notification` should have the following:
  * Provider: Slack, etc.
  * Payload
  * Options
  """
  @spec send_notification(Notifiex.config(), Notifiex.send_type()) :: Notifiex.result()
  def send_notification(notification, send_type) do
    # fetch sender
    sender = get_sender(send_type)

    case notification do
      {provider, payload, options} when is_atom(provider) and is_map(payload) and is_map(options) ->
        sender.(provider, payload, options)

      [_] ->
        {:error, {:missing, :payload}}

      _ ->
        {:error, {:invalid, :notification}}
    end
  end

  # sender mappings
  defp get_sender(:sync), do: &Notifiex.send/3
end
