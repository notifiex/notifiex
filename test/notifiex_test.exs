defmodule NotifiexTest do
  use ExUnit.Case

  test "must not work with unknown service" do
    # hope we support printers one day ;)
    result = Notifiex.send(:printer, %{}, %{})

    assert result == {:error, {:unknown_service, :printer}}
  end

  test "must work with payload" do
    result = Notifiex.send(:mock, %{hello: "world"}, %{})

    assert result == {:ok, true}
  end

  test "must not work with empty payload" do
    result = Notifiex.send(:mock, %{}, %{})

    assert result == {:error, {:mock_error, false}}
  end

  test "Slack notification must not work with missing params" do
    expected_result = {:error, {:missing_required_params}, nil}

    assert expected_result == Notifiex.send(:slack, nil, nil)
    assert expected_result == Notifiex.send(:slack, nil, %{})
    assert expected_result == Notifiex.send(:slack, %{}, nil)
    assert expected_result == Notifiex.send(:slack, %{}, %{})

    assert expected_result == Notifiex.send(:slack, %{text: "sample", channel: "channel"}, %{})
    assert expected_result == Notifiex.send(:slack, %{text: "sample"}, %{token: "token"})
    assert expected_result == Notifiex.send(:slack, %{channel: "channel"}, %{token: "token"})
    assert expected_result == Notifiex.send(:slack, %{}, %{token: "token"})
    assert expected_result == Notifiex.send(:slack, %{text: "sample"}, %{})
    assert expected_result == Notifiex.send(:slack, %{channel: "channel"}, %{})
  end

  test "Discord notification must not work with missing params" do
    expected_result = {:error, {:missing_required_params}, nil}

    assert expected_result == Notifiex.send(:discord, nil, nil)
    assert expected_result == Notifiex.send(:discord, nil, %{})
    assert expected_result == Notifiex.send(:discord, %{}, nil)
    assert expected_result == Notifiex.send(:discord, %{}, %{})

    assert expected_result == Notifiex.send(:discord, %{content: "sample"}, %{})
    assert expected_result == Notifiex.send(:discord, %{}, %{webhook: "webhook"})
  end
end
