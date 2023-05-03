defmodule Notifiex do
  @moduledoc """
  The main module for Notifiex.
  """

  use Application

  # type definitions

  @type id :: atom
  @type service :: atom
  @type payload :: binary
  @type options :: map
  @type result :: {:ok, any} | {:error, {atom, any}}
  @type send_type :: :sync | :async
  @type config :: {service, payload, options}

  def start(_start_type, _start_args) do
    Task.Supervisor.start_link(name: Notifiex.Supervisor, max_restarts: 2)
  end

  @doc """
  `send` helps in sending a notification through the specified service.

  Example:

  ```
  > Notifiex.send(:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"})
  ```
  """
  @spec send(service, payload, options) :: result
  def send(service, payload, options) do
    # fetch service
    handler = Keyword.get(services(), service)

    # if no service is found, return an error
    if is_nil(handler) do
      {:error, {:unknown_service, service}}
    else
      # call service with the payload and options
      handler.call(payload, options)
    end
  end

  @doc """
  `send_async` helps in sending a notification in an asynchronous way.

  Example:

  ```
  > Notifiex.send_async(:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"})
  ```
  """
  @spec send_async(service, payload, options) :: result
  def send_async(service, payload, options) do
    # fetch service
    handler = Keyword.get(services(), service)

    # if no service is found, return an error
    if is_nil(handler) do
      {:error, {:unknown_service, service}}
    else
      # call service with the payload and options using supervisor
      task = Task.Supervisor.async(Notifiex.Supervisor, fn -> handler.call(payload, options) end)
      {:ok, task}
    end
  end

  @doc """
  `send_multiple` helps in sending multiple notifications in a synchronous way.

  Example:

  ```elixir
  notifs = [
    slack_test: {:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"}},
    discord_test: {:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"}}
  ]

  Notifiex.send_multiple(notifs)
  ```
  """
  @spec send_multiple(any) :: [{Notifiex.id(), Notifiex.result()}]
  def send_multiple(notification) do
    notification
    |> Enum.map(fn {i, notification} ->
      {i, Notifiex.Notification.send_notification(notification, :sync)}
    end)
  end

  @doc """
  `send_async_multiple` helps in sending multiple notifications in an asynchronous way.

  Example:

  ```elixir
  notifs = [
    slack_test: {:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"}},
    discord_test: {:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"}}
  ]

  Notifiex.send_async_multiple(notifs)
  ```
  """
  @spec send_async_multiple(any) :: [{Notifiex.id(), Notifiex.result()}]
  def send_async_multiple(notification) do
    notification
    |> Enum.map(fn {i, notification} ->
      {i, Notifiex.Notification.send_notification(notification, :async)}
    end)
  end

  @doc """
  Returns a Keyword list of services.
  """
  @spec services() :: keyword
  def services do
    services = [
      slack: Notifiex.Service.Slack,
      discord: Notifiex.Service.Discord,
      mock: Notifiex.Service.Mock
    ]

    # return keyword list
    services
    |> Keyword.merge(Application.get_env(:notifiex, :services, []))
  end
end
