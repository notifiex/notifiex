defmodule Notifiex do
  @moduledoc """
  The main module for Notifiex.
  """

  use Application

  # type definitions

  @type id :: atom
  @type provider :: atom
  @type payload :: atom
  @type options :: atom
  @type result :: atom
  @type send_type :: :sync
  @type config :: {provider, payload, options}

  def start(_start_type, _start_args) do
    Task.Supervisor.start_link(name: Notifiex.Supervisor, max_restarts: 2)
  end

  @doc """
  `send` helps in sending a notification through the specified provider.

  Example:

  ```
  > Notifiex.send(:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"})
  ```
  """
  @spec send(provider, payload, options) :: result
  def send(provider, payload, options) do
    # fetch provider
    handler = Keyword.get(providers(), provider)

    # if no provider is found, return an error
    if is_nil(handler) do
      {:error, {:unknown_provider, provider}}
    else
      # call provider with the payload and options
      handler.call(payload, options)
    end
  end

  @doc """
  Returns a Keyword list of providers.
  """
  @spec providers() :: keyword
  def providers do
    providers = [
      slack: Notifiex.Provider.Slack,
      mock: Notifiex.Provider.Mock
    ]

    # return keyword list
    providers
    |> Keyword.merge(Application.get_env(:notifiex, :providers, []))
  end
end
