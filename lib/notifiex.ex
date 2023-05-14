defmodule Notifiex do
  @moduledoc """
  The main module for Notifiex.
  """

  use Application

  @type service :: atom
  @type payload :: map
  @type options :: map
  @type result :: {:ok, any} | {:error, {atom, any}}
  @type send_type :: :sync | :async
  @type config :: {service, payload, options}

  @doc """
    Sends a notification through the specified services.

    ## Examples

        iex> Notifiex.send([:slack, :discord], "Notifiex is cool!", %{webhook: "url", token: "SECRET"})
        [
          {:ok, "Message sent successfully"},
          {:ok, "Message sent successfully"}
        ]

  """
  @spec send([service()], payload :: any, options :: map, send_type :: (:sync | :async)) :: [result()]
  def send(services, payload, options, send_type) do
    sender = get_sender(send_type)
    sender.(services, payload, options)
  end

  defp get_sender(:sync), do: &send_sync/3
  defp get_sender(:async), do: &send_async/3

  defp send_sync(services, payload, options) do
    for service <- services do
      case get_service_handler(service) do
        nil -> {:error, {:unknown_service, service}}
        handler ->
          case handler.call(
            Map.put(payload, :files, Map.get(payload, :files, [])),
            Map.get(options, service, %{})
          ) do
            {:ok, _} -> {:ok, "Message sent successfully"}
            error -> {:error, error}
          end
      end
    end
  end

  defp send_async(services, payload, options) do
    for service <- services do
      case get_service_handler(service) do
        nil ->
          {:error, {:unknown_service, service}}

        handler ->
          task =
            Task.Supervisor.async(Notifiex.Supervisor, fn -> handler.call(Map.put(payload, :files, Map.get(payload, :files, [])),
            Map.get(options, service, %{})) end)

          {:ok, task}
      end
    end
  end

  def start(_start_type, _start_args) do
    Task.Supervisor.start_link(name: Notifiex.Supervisor, max_restarts: 2)
  end

  @doc """
  Returns a map of services.
  """
  @spec services() :: map
  def services do
    default_services = %{
      slack: Notifiex.Service.Slack,
      discord: Notifiex.Service.Discord,
      mock: Notifiex.Service.Mock
    }

    Application.get_env(:notifiex, :services, %{}) |> Map.merge(default_services)
  end

  defp get_service_handler(service), do: services()[service]
end
