defmodule NotifiexTest do
  use ExUnit.Case
  # doctest Notifiex

  test "must not work with unknown provider" do
    # hope we support printers one day ;)
    result = Notifiex.send(:printer, %{}, %{})

    assert result == {:error, {:unknown_provider, :printer}}
  end
end
