defmodule Notifiex.ServiceBehavior do
  @moduledoc """
  Interface for Notifiex services.
  """

  @callback call(Notifiex.payload(), Notifiex.options()) :: Notifiex.result()
end
