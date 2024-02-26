defmodule NotifiexTest do
  use ExUnit.Case, async: true

  setup_all do
    %{expected_missing_err: {:error, {:missing_required_params}, nil}}
  end

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

  test "Slack notification must not work with missing params", %{expected_missing_err: expected_missing_err} do
    for payload <- [nil, %{}, %{text: "sample", channel: "channel"}, %{text: "sample"}, %{channel: "channel"}],
        options <- [nil, %{}, %{token: "token"}],
        payload != %{text: "sample", channel: "channel"} && options != %{token: "token"} # exclude positive case
        do
      assert expected_missing_err == Notifiex.send(:slack, payload, options)
    end
  end

  test "Discord notification must not work with missing params", %{expected_missing_err: expected_missing_err} do
    for payload <- [nil, %{}, %{content: "sample"}],
        options <- [nil, %{}, %{webhook: "webhook"}],
        payload != %{content: "sample"} && options != %{webhook: "webhook"} # exclude positive case
        do
      assert expected_missing_err == Notifiex.send(:discord, payload, options)
    end
  end
end
