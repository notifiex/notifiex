<h1>Plugins</h1>

- [Creating a plugin](#creating-a-plugin)
- [Using plugins](#using-plugins)

## Creating a plugin

Create a new `mix` project, using `mix new notifiex_<plugin_name>`. For example, if you want to create a plugin for Mattermost, use the name `notifiex_mattermost`.

Once created, replace the contents of `lib/notifiex_mattermost.ex` with:

```elixir
defmodule NotifiexMattermost do
  @moduledoc """
  Mattermost service for Notifiex.
  """

  # must implement this behaviour
  @behaviour Notifiex.ServiceBehaviour

  @doc """
  Write docs.
  """
  @spec call(map, map) :: {:ok, binary} | {:error, {atom, any}}
  def call(payload, options) when is_map(payload) and is_map(options) do
    webhook = Map.get(options, :webhook)
    send_mattermost(payload, webhook)
  end

  # customize according to your needs

  @spec send_mattermost(map, binary) :: {:ok, binary} | {:error, {atom, any}}
  defp send_mattermost(_payload, nil), do: {:error, {:missing_options, nil}}

  defp send_mattermost(payload, url) do
    # write your dispatching logic
  end
end
```

**You could help the community by creating a plugin for any of [these services](https://github.com/burntcarrot/notifiex#services)! ❤️✨**

> **It is suggested to publish plugins through Github; not through hex.pm.**

## Using plugins

Using a plugin is very straightforward, just add the plugins to your app using `mix.exs`:

```elixir
....

  defp deps do
    [
      ....
      {:dep_from_git, git: "https://github.com/example/notifiex_mattermost.git", tag: "0.1.0"}
    ]
  end
```

and to the config:

```elixir
import Config

config :notifiex, services: [
  mattermost: NotifiexMattermost
]
```

Once configured, use it like this:

```elixir
Notifiex.send(:mattermost, %{content: "My first Notifiex plugin! 🚀"},  %{webhook: "SECRET"})
```
