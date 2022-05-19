defmodule Notifiex.ServiceBehaviour do
  @moduledoc """
  Interface for Notifiex services.
  """

  @callback call(Notifiex.payload(), Notifiex.options()) :: Notifiex.result()
end
