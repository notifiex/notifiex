defmodule NotifiexTest do
  use ExUnit.Case

  test "must not work with unknown service" do
    # hope we support printers one day ;)
    result = Notifiex.send(:printer, "{}", %{})

    assert result == {:error, {:unknown_service, :printer}}
  end

  test "must work with payload" do
    result = Notifiex.send(:mock, "{\"hello\": \"world\"}", %{})

    assert result == {:ok, true}
  end

  test "must not work with empty payload" do
    result = Notifiex.send(:mock, "", %{})

    assert result == {:error, {:mock_error, false}}
  end
end
