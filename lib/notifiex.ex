defmodule Notifiex do
  @moduledoc """
  The main module for Notifiex.
  """

  use Application

  # type definitions

  @type id :: atom
  @type service :: atom
  @type payload :: map
  @type options :: map
  @type result :: {:ok, any} | {:error, {atom, any}}
  @type send_type :: :sync
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
