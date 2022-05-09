defmodule Notifiex.ProviderBehavior do
  @moduledoc """
  Interface for Notifiex providers.
  """

  @callback call(Notifiex.payload(), Notifiex.options()) :: Notifiex.result()
end
