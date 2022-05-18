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

      @doc """
      `send_async` sends the notification in an asynchronous way.
      """
      @spec send_async(any) :: [{Notifiex.id(), Notifiex.result()}]
      def send_async(opts) do
        Notification.send_notification(opts, :async)
      end
    end
  end

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
      when is_atom(service) and is_map(payload) and is_map(options) ->
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
